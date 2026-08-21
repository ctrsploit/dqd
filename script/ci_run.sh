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
#
# The runner executes as user "runner" (not root); securityfs writes and
# apparmor_parser -R need CAP_MAC_ADMIN, so use sudo (passwordless on GHA).
disable_unix_chkpwd_apparmor() {
    echo "[ci] === AppArmor unix-chkpwd neutralize ==="
    # securityfs is usually mounted on ubuntu runners, but mount if not.
    sudo mountpoint -q /sys/kernel/security 2>/dev/null || \
        sudo mount -t securityfs securityfs /sys/kernel/security 2>/dev/null || true

    if [[ ! -d /sys/kernel/security/apparmor ]]; then
        echo "[ci] apparmor not active on this runner, skipping"
        return 0
    fi

    # apparmor-utils (aa-complain, aa-status) is not on the default GHA
    # ubuntu image; install it so we get the proper tooling.
    if ! sudo command -v aa-complain >/dev/null 2>&1; then
        echo "[ci] installing apparmor-utils..."
        sudo apt-get update -qq >/dev/null 2>&1 || true
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq apparmor-utils >/dev/null 2>&1 || true
    fi

    echo "[ci] --- profiles matching unix-chkpwd (before) ---"
    sudo grep -E 'unix-chkpwd|unix_chkpwd' /sys/kernel/security/apparmor/profiles 2>/dev/null || \
        echo "[ci] (no unix-chkpwd entry visible)"

    local neutralized=false

    # Method 1: aa-complain (handles profile-name resolution edge cases).
    if sudo command -v aa-complain >/dev/null 2>&1; then
        echo "[ci] trying: sudo aa-complain unix-chkpwd"
        if sudo aa-complain unix-chkpwd 2>&1; then
            neutralized=true
        fi
    fi

    # Method 2: direct .complain write (show the real error if it fails).
    if [[ "${neutralized}" != "true" ]]; then
        echo "[ci] trying: direct .complain write"
        if sudo sh -c 'echo unix-chkpwd > /sys/kernel/security/apparmor/.complain' 2>&1; then
            neutralized=true
        fi
    fi

    # Method 3: unload the profile entirely with apparmor_parser -R.
    if [[ "${neutralized}" != "true" ]]; then
        echo "[ci] trying: apparmor_parser -R"
        if sudo command -v apparmor_parser >/dev/null 2>&1; then
            local policy="/etc/apparmor.d/unix-chkpwd"
            if [[ -f "${policy}" ]]; then
                sudo apparmor_parser -R "${policy}" 2>&1 && neutralized=true || \
                    echo "[ci] WARNING: apparmor_parser -R failed"
            else
                echo "[ci] WARNING: ${policy} not found"
            fi
        else
            echo "[ci] WARNING: no apparmor_parser available"
        fi
    fi

    echo "[ci] --- profiles matching unix-chkpwd (after) ---"
    sudo grep -E 'unix-chkpwd|unix_chkpwd' /sys/kernel/security/apparmor/profiles 2>/dev/null || \
        echo "[ci] (no unix-chkpwd entry visible)"
    echo "[ci] === AppArmor neutralize done ==="
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
