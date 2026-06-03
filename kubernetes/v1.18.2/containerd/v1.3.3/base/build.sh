#!/bin/bash
set -euo pipefail

NETWORK_NAME="docker-archive-bridge"
NETWORK_SUBNET="10.0.2.0/24"
NETWORK_IP_RANGE="10.0.2.16/28"
NETWORK_GATEWAY="10.0.2.1"
BUILDER_NAME="docker-archive-builder"

load_env() {
    local script_dir env_file
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    env_file="${script_dir}/.env"
    if [[ -f "${env_file}" ]]; then
        set -a
        source <(grep -vE '^[[:space:]]*CI_MAKE_TARGETS=' "${env_file}")
        set +a
    fi
}

create_network() {
    docker network create --subnet "${NETWORK_SUBNET}" --ip-range "${NETWORK_IP_RANGE}" --gateway "${NETWORK_GATEWAY}" "${NETWORK_NAME}" 2>/dev/null || true
}

create_builder() {
    docker buildx create --driver-opt "network=${NETWORK_NAME}" --name "${BUILDER_NAME}" --buildkitd-flags "--allow-insecure-entitlement security.insecure" 2>/dev/null || true
}

prune_cache() {
    docker buildx --builder "${BUILDER_NAME}" prune --filter type=exec.cachemount -f || true
}

execute_build() {
    local image_tag="${1:?Error: Please provide image tag, e.g.: ./build.sh myimage:tag}"
    local progress_opt=""
    if [[ -z "${SANDBOX_HOSTNAME:-}" ]]; then
        echo "Error: SANDBOX_HOSTNAME is required. Set it in .env or export it before running build.sh." >&2
        exit 1
    fi
    if [[ "${DEBUG:-}" == "true" ]] || [[ "${DEBUG:-}" == "1" ]] || [[ "${DEBUG:-}" == "yes" ]]; then
        progress_opt="--progress=plain"
    fi
    docker buildx build --builder "${BUILDER_NAME}" --build-arg CACHE_BUST=$(date +%s) --build-arg BUILDKIT_SANDBOX_HOSTNAME="${SANDBOX_HOSTNAME}" ${progress_opt} --allow security.insecure --load -t "${image_tag}" .
}

load_env
create_network
create_builder
prune_cache
execute_build "${1}"
