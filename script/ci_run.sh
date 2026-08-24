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
# has .remove/.replace/.load but NO .disable/.complain. The .ns_* files
# confirm namespace stacking. A `docker run --privileged` container lands in
# a CHILD AppArmor namespace — it can SEE unix-chkpwd (profile visibility
# crosses namespaces) but .remove fails because the profile lives in the
# HOST namespace and .remove only affects the current namespace. --privileged
# grants all caps but does NOT pierce AppArmor namespace isolation.
#
# The fix: run directly on the runner via sudo (passwordless on GHA). The
# runner is in the HOST AppArmor namespace, so .remove can actually unload
# unix-chkpwd. Earlier sudo attempts (v0.1.11-v0.1.13) failed because they
# targeted .complain/.disable which don't exist on this kernel — not because
# sudo lacked caps.
#
# Build-time only (runner is ephemeral). No-op when AppArmor absent (dev).
disable_unix_chkpwd_apparmor() {
    echo "[ci] === AppArmor unix-chkpwd neutralize (direct on runner) ==="
    sudo bash -c '
        mount -t securityfs securityfs /sys/kernel/security 2>/dev/null || true
        if [ ! -d /sys/kernel/security/apparmor ]; then
            echo "apparmor not active on this runner"
            exit 0
        fi
        echo "profiles (before):"
        grep -E "unix-chkpwd|unix_chkpwd" /sys/kernel/security/apparmor/profiles 2>/dev/null || echo "(none visible)"
        echo "control files available:"
        ls -la /sys/kernel/security/apparmor/ 2>/dev/null

        # .remove unloads the profile from the kernel. We are in the host
        # AppArmor namespace (running directly on the runner, not in a
        # container), so this can remove host-loaded profiles. No 2>/dev/null
        # — let the actual error surface if it fails.
        if [ -f /sys/kernel/security/apparmor/.remove ]; then
            if echo unix-chkpwd > /sys/kernel/security/apparmor/.remove; then
                echo "unix-chkpwd profile removed via .remove"
                exit 0
            fi
            echo ".remove write failed (error above)"
        fi

        echo "WARNING: all methods failed"
        echo "profiles (after):"
        grep -E "unix-chkpwd|unix_chkpwd" /sys/kernel/security/apparmor/profiles 2>/dev/null || echo "(none visible)"
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

require_env_file
prepare_ssh_key
disable_unix_chkpwd_apparmor
trap stop_ci_dqd_env EXIT
run_nested_ci
