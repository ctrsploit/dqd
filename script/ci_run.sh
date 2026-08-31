#!/usr/bin/env bash
set -euo pipefail

ENV_DIR="${1:?ENV path is required}"
ENV_FILE="${ENV_DIR}/.env"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/ci_nested_lib.sh"

# GitHub Actions ubuntu runners ship a host-level AppArmor "unix-chkpwd"
# profile (enforce) that denies CAP_DAC_OVERRIDE to unix_chkpwd — the PAM
# helper sudo invokes to read /etc/shadow. harbor-log runs
# `sudo -u #10000 -E rsyslogd -n` → PAM → unix_chkpwd → denied → sudo fails
# → harbor-log crash-loops → install.sh fails.
#
# This kernel (Ubuntu 24.04 GHA runner) uses namespaced AppArmor: securityfs
# has .remove/.replace/.load but NO .disable/.complain, and .ns_* files prove
# namespace stacking. Writing a single profile name to .remove fails with
# ENOENT because the profile lives in a parent/peer namespace the runner shell
# can't target directly.
#
# The fix: disable AppArmor ENTIRELY by unloading all profiles. The LSM is
# compiled into the kernel so it can't be unloaded, but with zero profiles
# loaded it enforces nothing — effectively a no-op. Methods tried in order:
#   1. systemctl stop apparmor.service (service stop sequence unloads all)
#   2. aa-teardown (apparmor-utils bulk-unload, install if missing)
#   3. loop: write every profile name from `profiles` to `.remove`
# Build-time only (runner is ephemeral). No-op when AppArmor absent (dev).
disable_unix_chkpwd_apparmor() {
    echo "[ci] === AppArmor disable entirely (unload all profiles) ==="
    sudo bash -c '
        mount -t securityfs securityfs /sys/kernel/security 2>/dev/null || true
        if [ ! -d /sys/kernel/security/apparmor ]; then
            echo "apparmor not active on this runner"
            exit 0
        fi
        echo "profiles (before):"
        wc -l < /sys/kernel/security/apparmor/profiles 2>/dev/null || echo 0
        grep -E "unix-chkpwd|unix_chkpwd" /sys/kernel/security/apparmor/profiles 2>/dev/null || echo "(unix-chkpwd not visible)"

        # Method 1: stop the apparmor systemd service — its stop sequence
        # unloads all profiles the service manages.
        if systemctl stop apparmor.service 2>/dev/null; then
            echo "apparmor.service stopped"
        else
            echo "apparmor.service stop failed (not loaded or no unit)"
        fi

        # Method 2: aa-teardown bulk-unloads every profile. Install
        # apparmor-utils if the command is missing.
        if ! command -v aa-teardown >/dev/null 2>&1; then
            apt-get update -qq >/dev/null 2>&1 && apt-get install -y -qq apparmor-utils >/dev/null 2>&1 || true
        fi
        if command -v aa-teardown >/dev/null 2>&1; then
            aa-teardown 2>/dev/null && echo "aa-teardown ran" || echo "aa-teardown failed"
        else
            echo "aa-teardown unavailable"
        fi

        # Method 3: brute-force — write every profile name to .remove.
        if [ -f /sys/kernel/security/apparmor/.remove ]; then
            removed=0
            while IFS= read -r line; do
                # profiles format: "name (mode)" — extract the name
                pname="${line%% *}"
                [ -n "$pname" ] || continue
                if echo "$pname" > /sys/kernel/security/apparmor/.remove 2>/dev/null; then
                    removed=$((removed + 1))
                fi
            done < /sys/kernel/security/apparmor/profiles 2>/dev/null
            echo ".remove loop: $removed profiles removed"
        fi

        echo "profiles (after):"
        wc -l < /sys/kernel/security/apparmor/profiles 2>/dev/null || echo 0
        grep -E "unix-chkpwd|unix_chkpwd" /sys/kernel/security/apparmor/profiles 2>/dev/null || echo "(unix-chkpwd gone or not visible)"
    ' 2>&1 | sed 's/^/[ci] /'
    echo "[ci] === done ==="
}

run_direct_ci() {
    # Cluster envs (kubernetes master+worker) need a coordinated dual build in
    # one job: the master ctr build hangs until the worker joins it. Detect them
    # by the absence of IMAGE in the top-level .env plus master/ worker/ subdirs.
    if [[ -z "$(env_value IMAGE)" && -d "${ENV_DIR}/master" && -d "${ENV_DIR}/worker" ]]; then
        bash "${SCRIPT_DIR}/ci_cluster.sh" "${ENV_DIR}"
        return
    fi
    make ci ENV="${ENV_DIR}"
}

pull_nested_ctr_image() {
    local image version ctr_tag

    image="$(env_value IMAGE)"
    version="$(env_value VERSION)"
    ctr_tag="${REGISTRY}/${NAMESPACE}/${image}:ctr_${version}"
    docker pull "${ctr_tag}"
}

run_nested_ci() {
    local nested_targets host_targets

    set_ci_dqd_builder
    nested_targets="$(env_value CI_DQD_MAKE_TARGETS)"
    host_targets="$(env_value CI_DQD_HOST_MAKE_TARGETS)"

    if [[ -z "${CI_DQD_BUILDER}" ]]; then
        run_direct_ci
        return
    fi
    if [[ -z "${nested_targets}" ]]; then
        nested_targets="ctr push-ctr"
    fi
    if [[ -z "${host_targets}" ]]; then
        host_targets="vm dqd push-dqd post-clean generate_ssh_config"
    fi
    set_ci_dqd_ssh_port

    echo "Running CI build targets '${nested_targets}' for ENV=${ENV_DIR} inside ${CI_DQD_BUILDER}"
    ensure_ci_dqd_builder_image
    start_ci_dqd_env
    wait_for_ssh
    prepare_ci_dqd_env
    login_to_ghcr_inside_dqd
    sync_workspace
    ssh_in_dqd "cd '${CI_DQD_WORKDIR}' && make ci ENV='${ENV_DIR}' CI_MAKE_TARGETS='${nested_targets}' REGISTRY='${REGISTRY}' NAMESPACE='${NAMESPACE}'"
    pull_nested_ctr_image
    stop_ci_dqd_env

    echo "Running CI host targets '${host_targets}' for ENV=${ENV_DIR}"
    make ci ENV="${ENV_DIR}" CI_MAKE_TARGETS="clean ${host_targets}"
}

# Disk-budget observability: GitHub-hosted runners expose ~10-20G free on /
# (plus a mostly-empty ~70G volume at /mnt). The vm target (d2vm convert +
# virt-sparsify) is the disk-hungriest step and fails as an opaque
# "virt-sparsify: exception: End_of_file" when the runner runs out — log the
# budget up front so failed runs show how much was actually left.
log_disk_budget() {
    echo "[ci] disk budget at job start:"
    df -h / /mnt 2>/dev/null | sed 's/^/[ci]     /'
}

require_env_file
prepare_ssh_key
log_disk_budget

# The GHA ubuntu runner ships a host-level AppArmor "unix-chkpwd" profile
# (enforce) that breaks harbor's `sudo -u #10000 -E rsyslogd -n` PAM path.
# Only harbor/v2.15.2 is affected; other envs build fine with AppArmor
# active, and unloading profiles globally can leave the runner's runc
# unable to apply the default AppArmor profile during `docker build`
# (`write fsmount:fscontext:proc/thread-self/attr/apparmor/exec: no such
# file or directory`). Gate the workaround on the harbor env so non-harbor
# builds keep working.
if [[ "${ENV_DIR}" == "harbor/"* ]]; then
    disable_unix_chkpwd_apparmor
fi

trap stop_ci_dqd_env EXIT
run_nested_ci
