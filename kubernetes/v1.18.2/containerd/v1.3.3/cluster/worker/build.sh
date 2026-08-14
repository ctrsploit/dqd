#!/bin/bash
set -euo pipefail

# ============================================================================
# Configuration - modify as needed
# ============================================================================
NETWORK_NAME="docker-archive-bridge"
NETWORK_SUBNET="10.0.2.0/24"
NETWORK_IP_RANGE="10.0.2.16/28"
NETWORK_GATEWAY="10.0.2.1"

# ============================================================================
# Functions
# ============================================================================

load_env() {
    local script_dir env_file

    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    env_file="${script_dir}/.env"

    if [[ -f "${env_file}" ]]; then
        set -a
        # CI_MAKE_TARGETS/CI_DQD_* use Make-style values and are not valid
        # shell assignments (or are CI-only); skip them.
        # shellcheck disable=SC1090,SC1091
        source <(grep -vE '^[[:space:]]*(CI_MAKE_TARGETS|CI_DQD_)=' "${env_file}")
        set +a
    fi
}

# https://github.com/kubernetes/kubernetes/issues/122745
# fix kube-proxy: `failed to write "a *:* rwm" to devices.allow: operation not permitted`
fix_nf_conntrack_max() {
  local PARAM_PATH="/sys/module/nf_conntrack/parameters/hashsize"
  local SYSCTL_PATH="/proc/sys/net/netfilter/nf_conntrack_max"

  if [[ ! -e "$PARAM_PATH" || ! -e "$SYSCTL_PATH" ]]; then
    echo "Error: missing system path." >&2
    return 1
  fi

  local MAX TARGET_HASHSIZE CURRENT_HASHSIZE
  MAX=$(< "$SYSCTL_PATH")
  TARGET_HASHSIZE=$(( MAX / 4 ))
  CURRENT_HASHSIZE=$(< "$PARAM_PATH")

  if (( CURRENT_HASHSIZE < TARGET_HASHSIZE )); then
    echo "Updating nf_conntrack hashsize to $TARGET_HASHSIZE"
    echo "$TARGET_HASHSIZE" > "$PARAM_PATH"
  else
    echo "Current hashsize ($CURRENT_HASHSIZE) is sufficient"
  fi
}

fix_nf_conntrack_hashsize() {
  local PARAM_PATH="/sys/module/nf_conntrack/parameters/hashsize"

  if [[ ! -e "$PARAM_PATH" ]]; then
    echo "nf_conntrack module not loaded; skipping hashsize fix" >&2
    return 0
  fi

  local MAX TARGET_HASHSIZE CURRENT_HASHSIZE
  MAX=$(< /proc/sys/net/netfilter/nf_conntrack_max)
  TARGET_HASHSIZE=$(( MAX / 4 ))
  CURRENT_HASHSIZE=$(< "$PARAM_PATH")

  if (( CURRENT_HASHSIZE < TARGET_HASHSIZE )); then
    echo "Updating nf_conntrack hashsize to $TARGET_HASHSIZE"
    echo "$TARGET_HASHSIZE" > "$PARAM_PATH"
  else
    echo "Current hashsize ($CURRENT_HASHSIZE) is sufficient"
  fi
}

fix_nf_conntrack_max || true
fix_nf_conntrack_hashsize || true

# Create custom network (for buildx)
# https://docs.docker.com/build/builders/drivers/docker-container/#custom-network
create_network() {
    docker network create \
        --subnet "${NETWORK_SUBNET}" \
        --ip-range "${NETWORK_IP_RANGE}" \
        --gateway "${NETWORK_GATEWAY}" \
        "${NETWORK_NAME}" 2>/dev/null || true
}

# Create buildx builder
create_builder() {
    local builder_name="${BUILDER_NAME:?Error: BUILDER_NAME is required. Set it in .env}"
    docker buildx create \
        --driver-opt "network=${NETWORK_NAME}" \
        --name "${builder_name}" \
        --buildkitd-flags "--allow-insecure-entitlement security.insecure" \
        2>/dev/null || true
}

# Prune buildx cache
prune_cache() {
    local builder_name="${BUILDER_NAME:-}"
    docker buildx --builder "${builder_name}" prune \
        --filter type=exec.cachemount -f || true
}

# Prepare kernel modules
prepare_modules() {
    local kernel_version
    kernel_version=$(uname -r)
    mkdir -p modules
    cp "/lib/modules/${kernel_version}" "modules/${kernel_version}" -r
}

# Cleanup kernel modules
cleanup_modules() {
    rm -rf modules
}

# Execute Docker buildx build
execute_build() {
    local image_tag="${1:?Error: Please provide image tag, e.g.: ./build.sh myimage:tag}"
    local progress_opt=""
    local builder_name="${BUILDER_NAME:?Error: BUILDER_NAME is required. Set it in .env}"

    if [[ -z "${SANDBOX_HOSTNAME:-}" ]]; then
        echo "Error: SANDBOX_HOSTNAME is required. Set it in .env or export it before running build.sh." >&2
        exit 1
    fi

    # Determine progress option based on DEBUG environment variable
    if [[ "${DEBUG:-}" == "true" ]] || [[ "${DEBUG:-}" == "1" ]] || [[ "${DEBUG:-}" == "yes" ]]; then
        progress_opt="--progress=plain"
    fi

    docker buildx build \
        --builder "${builder_name}" \
        --build-arg CACHE_BUST=$(date +%s) \
        --build-arg BUILDKIT_SANDBOX_HOSTNAME="${SANDBOX_HOSTNAME}" \
        ${progress_opt} \
        ${BUILD_EXTRA_ARGS:-} \
        --allow security.insecure \
        --load \
        -t "${image_tag}" \
        .
}

# ============================================================================
# Script entry point
# ============================================================================
load_env
create_network
create_builder
prune_cache
prepare_modules
execute_build "${1}"
cleanup_modules
