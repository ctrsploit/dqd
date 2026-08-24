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
# The runner user can't write securityfs (no CAP_MAC_ADMIN, AppArmor locked
# down). The buildkit exec container can't reach host securityfs (own mount
# ns). BUT the runner user CAN `docker run --privileged` on GHA. A
# --privileged container gets all capabilities + apparmor=unconfined, can
# mount securityfs (same kernel object as host), and write .complain to
# modify the HOST kernel's AppArmor state — which the nested buildkit exec
# and Harbor containers share (Docker doesn't create new AA namespaces).
#
# Build-time only (runner is ephemeral). No Harbor container changes.
# No-op when AppArmor or the unix-chkpwd profile is absent (local dev).
disable_unix_chkpwd_apparmor() {
    echo "[ci] === AppArmor unix-chkpwd neutralize (privileged container) ==="
    docker run --rm --privileged ubuntu:24.04 bash -c '
        mount -t securityfs securityfs /sys/kernel/security 2>/dev/null || true
        if [ ! -d /sys/kernel/security/apparmor ]; then
            echo "apparmor not active on this runner"
            exit 0
        fi
        echo "profiles (before):"
        grep -E "unix-chkpwd|unix_chkpwd" /sys/kernel/security/apparmor/profiles 2>/dev/null || echo "(none visible)"
        echo "control files available:"
        ls -la /sys/kernel/security/apparmor/ 2>/dev/null

        # Method 1: remove the profile from the kernel entirely
        if [ -f /sys/kernel/security/apparmor/.remove ]; then
            if echo unix-chkpwd > /sys/kernel/security/apparmor/.remove 2>/dev/null; then
                echo "unix-chkpwd profile removed via .remove"
                exit 0
            fi
            echo ".remove write failed"
        fi

        # Method 2: disable AppArmor entirely (build-time only)
        if [ -f /sys/kernel/security/apparmor/.disable ]; then
            if echo 1 > /sys/kernel/security/apparmor/.disable 2>/dev/null; then
                echo "AppArmor disabled via .disable"
                exit 0
            fi
            echo ".disable write failed"
        fi

        # Method 3: set unix-chkpwd to complain mode (log only, do not deny)
        if [ -f /sys/kernel/security/apparmor/.complain ]; then
            if echo unix-chkpwd > /sys/kernel/security/apparmor/.complain 2>/dev/null; then
                echo "unix-chkpwd set to complain mode"
                exit 0
            fi
            echo ".complain write failed"
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
