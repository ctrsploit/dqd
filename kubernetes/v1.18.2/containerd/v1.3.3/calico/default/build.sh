#!/bin/bash
set -euo pipefail

NETWORK_NAME="dqd-k8s-1182-calico-buildx"
NETWORK_SUBNET="10.0.2.0/24"
NETWORK_IP_RANGE="10.0.2.16/28"
NETWORK_GATEWAY="10.0.2.1"
BUILDER_NAME="dqd-k8s-1182-calico-builder"
# Pin buildkit: moby/buildkit:buildx-stable-1 is a moving tag that now points at
# v0.31.2, whose runc masks /proc/acpi with a tmpfs remount (nr_blocks=1,nr_inodes=1)
# that the cgroup-v1-builder VM's kernel 5.4 rejects, breaking every RUN. v0.30.0 is
# what buildx-stable-1 resolved to when v1.18.2 init built successfully on Jun 4 2026.
BUILDX_IMAGE="moby/buildkit:v0.30.0"
NF_CONNTRACK_HASHSIZE="/sys/module/nf_conntrack/parameters/hashsize"
NF_CONNTRACK_MAX="/proc/sys/net/netfilter/nf_conntrack_max"

load_env() {
    local script_dir env_file

    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    env_file="${script_dir}/.env"

    if [[ -f "${env_file}" ]]; then
        set -a
        source <(grep -vE '^[[:space:]]*(CI_MAKE_TARGETS|CI_DQD_[A-Za-z0-9_]+)=' "${env_file}")
        set +a
    fi
}

require_cgroup_v1() {
    local fs_type

    fs_type="$(stat -fc %T /sys/fs/cgroup)"
    if [[ "${fs_type}" != "tmpfs" ]]; then
        echo "Error: Kubernetes v1.18.2 kubelet requires cgroup v1; /sys/fs/cgroup is ${fs_type}." >&2
        echo "Build this env with CI_DQD_BUILDER=dqd/cgroup-v1-builder, or on a cgroup-v1 host." >&2
        exit 1
    fi
}

prepare_nf_conntrack() {
    local max target_hashsize current_hashsize

    if [[ ! -r "${NF_CONNTRACK_MAX}" || ! -w "${NF_CONNTRACK_HASHSIZE}" ]]; then
        echo "Skipping nf_conntrack hashsize setup; required sysctls are unavailable." >&2
        return
    fi

    max="$(<"${NF_CONNTRACK_MAX}")"
    target_hashsize=$(( max / 4 ))
    current_hashsize="$(<"${NF_CONNTRACK_HASHSIZE}")"

    if (( current_hashsize < target_hashsize )); then
        echo "Updating nf_conntrack hashsize to ${target_hashsize}"
        echo "${target_hashsize}" > "${NF_CONNTRACK_HASHSIZE}"
    else
        echo "Current nf_conntrack hashsize (${current_hashsize}) is enough"
    fi
}

create_network() {
    docker network create \
        --subnet "${NETWORK_SUBNET}" \
        --ip-range "${NETWORK_IP_RANGE}" \
        --gateway "${NETWORK_GATEWAY}" \
        "${NETWORK_NAME}" 2>/dev/null || true
}

create_builder() {
    docker buildx create \
        --driver-opt "network=${NETWORK_NAME}" \
        --driver-opt "image=${BUILDX_IMAGE}" \
        --name "${BUILDER_NAME}" \
        --buildkitd-flags "--allow-insecure-entitlement security.insecure" \
        2>/dev/null || true
}

prune_cache() {
    docker buildx --builder "${BUILDER_NAME}" prune \
        --filter type=exec.cachemount -f || true
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

    docker buildx build \
        --builder "${BUILDER_NAME}" \
        --build-arg CACHE_BUST="$(date +%s)" \
        --build-arg BUILDKIT_SANDBOX_HOSTNAME="${SANDBOX_HOSTNAME}" \
        ${progress_opt} \
        --allow security.insecure \
        --load \
        -t "${image_tag}" \
        .
}

load_env
require_cgroup_v1
prepare_nf_conntrack
create_network
create_builder
prune_cache
execute_build "${1}"
