#!/usr/bin/env bash
# Build a kubernetes cluster environment (master + worker) in one CI job.
#
# The master build hangs until a worker joins (its init.sh waits for a worker
# node to become Ready), so the two ctr builds must overlap inside the same
# docker daemon (same docker-archive-bridge network, master sandbox reachable
# at 10.0.2.16). This script runs them sequentially-in-parallel: master in the
# background, then worker once the master API answers /healthz.
#
# Nested mode: if cluster/master/.env sets CI_DQD_BUILDER (old k8s releases
# need a cgroup-v1 builder VM), the ctr coordination runs inside that builder
# VM; the vm/dqd/push stages then run on the CI host. Inside the builder VM the
# script is re-invoked with CI_CLUSTER_DIRECT=1 CI_CLUSTER_STAGES='ctr push-ctr'
# to avoid recursive nesting.
#
# The vm/dqd stages of master and worker are independent single-env builds and
# run strictly one at a time to bound disk usage on the runner.
set -euo pipefail

CLUSTER_DIR="${1:?cluster env dir is required}"
MASTER="${CLUSTER_DIR}/master"
WORKER="${CLUSTER_DIR}/worker"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/ci_nested_lib.sh"

CI_CLUSTER_STAGES="${CI_CLUSTER_STAGES:-all}"
CI_CLUSTER_DIRECT="${CI_CLUSTER_DIRECT:-}"

MASTER_BUILDER="${MASTER_BUILDER:-docker-archive-builder}"
MASTER_API="10.0.2.16:6443"
# The master sandbox API answers /healthz within ~2-5 minutes of the sandbox
# booting (local measurements). 10 minutes is enough margin while still failing
# fast enough to keep CI debugging cheap.
API_READY_TIMEOUT="${API_READY_TIMEOUT:-600}"
PROBE_INTERVAL="${PROBE_INTERVAL:-15}"
MASTER_CTR_LOG="${MASTER_CTR_LOG:-/tmp/cluster-master-ctr.log}"

log() {
    echo "[ci_cluster] $1"
}

cleanup() {
    kill "${MASTER_CTR_PID:-}" 2>/dev/null || true
    wait "${MASTER_CTR_PID:-}" 2>/dev/null || true
}
trap cleanup EXIT

# ---------------------------------------------------------------------------
# Wait until the master sandbox API server answers /healthz.
# Probe from inside the docker-archive-bridge network with a throwaway
# container: the buildkit sandbox shares the builder container's network
# stack, whose IP is the first address of the bridge's ip-range (10.0.2.16).
# This avoids depending on the buildx container naming scheme.
# ---------------------------------------------------------------------------
wait_api_ready() {
    local deadline now probe_out last_err=0
    deadline=$((SECONDS + API_READY_TIMEOUT))
    while true; do
        probe_out="$(docker run --rm --network docker-archive-bridge \
            curlimages/curl:8.9.1 -sk --max-time 5 \
            "https://${MASTER_API}/healthz" 2>&1 || true)"
        if grep -q ok <<<"${probe_out}"; then
            log "master API is ready"
            return 0
        fi
        if ! kill -0 "${MASTER_CTR_PID}" 2>/dev/null; then
            log "master ctr build died before the API became ready" >&2
            tail -n 40 "${MASTER_CTR_LOG}" >&2 || true
            return 1
        fi
        now="${SECONDS}"
        if (( now >= deadline )); then
            log "timeout (${API_READY_TIMEOUT}s) waiting for the master API" >&2
            log "last probe output: ${probe_out}" >&2
            log "--- diagnostics ---" >&2
            docker network inspect docker-archive-bridge >&2 || true
            docker ps -a --format '{{.Names}} {{.Status}}' >&2 || true
            tail -n 60 "${MASTER_CTR_LOG}" >&2 || true
            return 1
        fi
        # surface probe failures every ~2 minutes so a live-watching human
        # can tell the difference between "sandbox still booting" and
        # "probe is broken"
        if (( (now / 120) != (last_err / 120) )); then
            last_err="${now}"
            log "master API not ready yet (t+$((SECONDS))s), last probe: ${probe_out}" >&2
        fi
        sleep "${PROBE_INTERVAL}"
    done
}

# ---------------------------------------------------------------------------
# The coordinated dual ctr build (+ optional push-ctr for nested mode)
# ---------------------------------------------------------------------------
run_ctr_coordination() {
    log "starting master ctr build (background, log: ${MASTER_CTR_LOG}): ${MASTER}"
    make ctr ENV="${MASTER}" > "${MASTER_CTR_LOG}" 2>&1 &
    MASTER_CTR_PID=$!

    wait_api_ready

    # Give the master init.sh a moment to recreate the bootstrap token (it does
    # this first thing; the worker join has its own retry loop as a fallback).
    sleep 30

    log "starting worker ctr build (foreground): ${WORKER}"
    make ctr ENV="${WORKER}"

    log "waiting for the master ctr build to finish"
    wait "${MASTER_CTR_PID}"
    MASTER_CTR_PID=""
    trap - EXIT

    if [[ "${CI_CLUSTER_STAGES}" == *push-ctr* ]]; then
        make push-ctr ENV="${MASTER}"
        make push-ctr ENV="${WORKER}"
    fi
}

# ---------------------------------------------------------------------------
# vm/dqd/push for both envs, one at a time (bound runner disk usage)
# ---------------------------------------------------------------------------
run_vm_dqd_phase() {
    for env in "${MASTER}" "${WORKER}"; do
        log "building vm/dqd for ${env}"
        make ci ENV="${env}" CI_MAKE_TARGETS="clean vm dqd push post-clean"
        docker image rm -f "$(sed -n 's/^image: *//p' "${env}/docker-compose.yml" | head -n1)" || true
    done
}

pull_cluster_ctr_images() {
    local image version ctr_tag
    for env in "${MASTER}" "${WORKER}"; do
        ENV_FILE="${env}/.env"
        image="$(env_value IMAGE)"
        version="$(env_value VERSION)"
        ctr_tag="${REGISTRY}/${NAMESPACE}/${image}:ctr_${version}"
        docker pull "${ctr_tag}"
    done
}

# ---------------------------------------------------------------------------
# Nested mode: coordinate the ctr builds inside the builder VM (cgroup-v1 for
# old releases), then run vm/dqd/push on the host
# ---------------------------------------------------------------------------
run_cluster_nested() {
    ENV_FILE="${MASTER}/.env"
    set_ci_dqd_builder
    set_ci_dqd_ssh_port

    log "running cluster ctr build inside ${CI_DQD_BUILDER}"
    ensure_ci_dqd_builder_image
    start_ci_dqd_env
    wait_for_ssh
    prepare_ci_dqd_env
    login_to_ghcr_inside_dqd
    sync_workspace
    ssh_in_dqd "cd '${CI_DQD_WORKDIR}' && CI_CLUSTER_STAGES='ctr push-ctr' CI_CLUSTER_DIRECT=1 bash script/ci_cluster.sh '${CLUSTER_DIR}' REGISTRY='${REGISTRY}' NAMESPACE='${NAMESPACE}'"
    stop_ci_dqd_env

    pull_cluster_ctr_images
    run_vm_dqd_phase
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
if [[ -z "${CI_CLUSTER_DIRECT}" ]]; then
    ENV_FILE="${MASTER}/.env"
    require_env_file
    if [[ -n "$(env_value CI_DQD_BUILDER)" ]]; then
        run_cluster_nested
        exit 0
    fi
fi

if [[ "${CI_CLUSTER_STAGES}" != "all" ]]; then
    run_ctr_coordination
    exit 0
fi

run_ctr_coordination
run_vm_dqd_phase
log "cluster build complete"
