#!/usr/bin/env bash
set -euo pipefail

ENV_DIR="${1:?ENV path is required}"
ENV_FILE="${ENV_DIR}/.env"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/ci_nested_lib.sh"

# GitHub Actions ubuntu runners ship a host-level AppArmor "unix-chkpwd"
# profile (enforce) that denies CAP_DAC_OVERRIDE to unix_chkpwd — the PAM
# helper sudo invokes to read /etc/shadow. Builds that start nested
# containers running `sudo -u <uid>` + PAM (e.g. Harbor's harbor-log) then
# fail: unix_chkpwd is denied dac_override → sudo fails ("a password is
# required") → the container crash-loops → the build fails. This is invisible
# locally (no unix-chkpwd profile) and can't be fixed from inside the
# buildkit exec container, whose AppArmor namespace can't see the host
# profile. Neutralize it on the runner (root, before any make) instead.
# No-op when AppArmor or the unix-chkpwd profile is absent.
disable_unix_chkpwd_apparmor() {
    [[ -d /sys/kernel/security/apparmor ]] || return 0
    grep -q '^unix-chkpwd (enforce)' /sys/kernel/security/apparmor/profiles 2>/dev/null || return 0
    if echo unix-chkpwd > /sys/kernel/security/apparmor/.complain 2>/dev/null; then
        echo "[ci] set AppArmor unix-chkpwd to complain mode"
    else
        echo "[ci] WARNING: could not set unix-chkpwd to complain mode" >&2
    fi
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
