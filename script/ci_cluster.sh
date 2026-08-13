#!/usr/bin/env bash
# Build a kubernetes cluster environment (master + worker) in one CI job.
#
# The master build hangs until a worker joins (its init.sh waits for a worker
# node to become Ready), so the two ctr builds must overlap inside the same
# docker daemon (same docker-archive-bridge network, master sandbox reachable
# at 10.0.2.16). This script runs them sequentially-in-parallel: master in the
# background, then worker once the master API answers /healthz.
#
# The vm/dqd stages of master and worker are independent single-env builds and
# run strictly one at a time to bound disk usage on the runner.
set -euo pipefail

CLUSTER_DIR="${1:?cluster env dir is required}"
MASTER="${CLUSTER_DIR}/master"
WORKER="${CLUSTER_DIR}/worker"

MASTER_BUILDER="${MASTER_BUILDER:-docker-archive-builder}"
MASTER_API="10.0.2.16:6443"
API_READY_TIMEOUT="${API_READY_TIMEOUT:-1800}"

log() {
    echo "[ci_cluster] $1"
}

cleanup() {
    kill "${MASTER_CTR_PID}" 2>/dev/null || true
    wait "${MASTER_CTR_PID}" 2>/dev/null || true
}
trap cleanup EXIT

# ---------------------------------------------------------------------------
# 1. Start the master ctr build in the background (its init.sh waits for join)
# ---------------------------------------------------------------------------
log "starting master ctr build (background): ${MASTER}"
make ctr ENV="${MASTER}" &
MASTER_CTR_PID=$!

# ---------------------------------------------------------------------------
# 2. Wait until the master sandbox API server answers /healthz.
#    Probe from inside the docker-archive-bridge network with a throwaway
#    container: the buildkit sandbox shares the builder container's network
#    stack, whose IP is the first address of the bridge's ip-range (10.0.2.16).
#    This avoids depending on the buildx container naming scheme.
# ---------------------------------------------------------------------------
wait_api_ready() {
    local deadline now
    deadline=$((SECONDS + API_READY_TIMEOUT))
    while true; do
        if docker run --rm --network docker-archive-bridge \
            curlimages/curl:8.9.1 -sk --max-time 5 \
            "https://${MASTER_API}/healthz" 2>/dev/null | grep -q ok; then
            log "master API is ready"
            return 0
        fi
        if ! kill -0 "${MASTER_CTR_PID}" 2>/dev/null; then
            log "master ctr build died before the API became ready" >&2
            return 1
        fi
        now="${SECONDS}"
        if (( now >= deadline )); then
            log "timeout (${API_READY_TIMEOUT}s) waiting for the master API" >&2
            return 1
        fi
        sleep 15
    done
}
wait_api_ready

# Give the master init.sh a moment to recreate the bootstrap token (it does
# this first thing; the worker join has its own retry loop as a fallback).
sleep 30

# ---------------------------------------------------------------------------
# 3. Build the worker (kubeadm join against the master sandbox)
# ---------------------------------------------------------------------------
log "starting worker ctr build (foreground): ${WORKER}"
make ctr ENV="${WORKER}"

# ---------------------------------------------------------------------------
# 4. The master build finishes on its own once it sees the worker Ready
# ---------------------------------------------------------------------------
log "waiting for the master ctr build to finish"
wait "${MASTER_CTR_PID}"
MASTER_CTR_PID=""
trap - EXIT

# ---------------------------------------------------------------------------
# 5. vm/dqd/push for both envs, one at a time (bound runner disk usage);
#    each push is followed by cleanup of the local image/qcow2
# ---------------------------------------------------------------------------
for env in "${MASTER}" "${WORKER}"; do
    log "building vm/dqd for ${env}"
    make ci ENV="${env}" CI_MAKE_TARGETS="vm dqd push post-clean"
    docker image rm -f "$(sed -n 's/^image: *//p' "${env}/docker-compose.yml" | head -n1)" || true
done

log "cluster build complete"
