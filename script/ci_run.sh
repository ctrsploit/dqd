#!/usr/bin/env bash
set -euo pipefail

ENV_DIR="${1:?ENV path is required}"
ENV_FILE="${ENV_DIR}/.env"
CI_DQD_WORKDIR="${CI_DQD_WORKDIR:-/root/dqd}"
CI_DQD_SSH_PORT="${CI_DQD_SSH_PORT:-}"
CI_DQD_SSH_USER="${CI_DQD_SSH_USER:-root}"
CI_DQD_SSH_HOST="${CI_DQD_SSH_HOST:-127.0.0.1}"
CI_DQD_SSH_KEY="${CI_DQD_SSH_KEY:-ssh_config/dqd}"
CI_DQD_CONNECT_TIMEOUT="${CI_DQD_CONNECT_TIMEOUT:-300}"
CI_DQD_BUILDX_VERSION="${CI_DQD_BUILDX_VERSION:-v0.14.1}"
CI_DQD_QEMU_NET="${CI_DQD_QEMU_NET:-10.200.0.0/24}"
CI_DQD_QEMU_DHCPSTART="${CI_DQD_QEMU_DHCPSTART:-10.200.0.16}"
REGISTRY="${REGISTRY:-ghcr.io}"
NAMESPACE="${NAMESPACE:-ctrsploit}"
CI_DQD_COMPOSE_OVERRIDE=""
CI_DQD_STARTED=false
CI_DQD_COMPOSE_ARGS=()

env_value() {
    local key="$1"
    sed -n "s/^${key}=//p" "${ENV_FILE}" | head -n1 | tr -d '"'
}

require_env_file() {
    if [[ ! -f "${ENV_FILE}" ]]; then
        echo "Missing env file: ${ENV_FILE}" >&2
        exit 1
    fi
}

prepare_ssh_key() {
    if [[ -f "${CI_DQD_SSH_KEY}" ]]; then
        chmod 600 "${CI_DQD_SSH_KEY}"
    fi
}

ssh_port_from_compose() {
    local compose_file="$1"
    sed -nE 's/^[[:space:]]*-[[:space:]]*"?([0-9]+):22"?[[:space:]]*(#.*)?$/\1/p' "${compose_file}" | head -n1
}

image_from_compose() {
    local compose_file="$1"
    sed -nE 's/^[[:space:]]*image:[[:space:]]*"?([^"]+)"?[[:space:]]*$/\1/p' "${compose_file}" | head -n1
}

set_ci_dqd_ssh_port() {
    if [[ -n "${CI_DQD_SSH_PORT}" ]]; then
        return
    fi

    CI_DQD_SSH_PORT="$(ssh_port_from_compose "${CI_DQD_BUILDER}/docker-compose.yml")"
    if [[ -z "${CI_DQD_SSH_PORT}" ]]; then
        echo "Failed to detect SSH port from ${CI_DQD_BUILDER}/docker-compose.yml" >&2
        exit 1
    fi
}

set_ci_dqd_builder() {
    CI_DQD_BUILDER="$(env_value CI_DQD_BUILDER)"
}

ssh_args() {
    printf '%s\n' \
        -i "${CI_DQD_SSH_KEY}" \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        -p "${CI_DQD_SSH_PORT}" \
        "${CI_DQD_SSH_USER}@${CI_DQD_SSH_HOST}"
}

ssh_in_dqd() {
    local args
    mapfile -t args < <(ssh_args)
    ssh "${args[@]}" "$@"
}

wait_for_ssh() {
    local deadline now
    deadline=$((SECONDS + CI_DQD_CONNECT_TIMEOUT))
    while true; do
        if ssh_in_dqd true 2>/dev/null; then
            return 0
        fi
        now="${SECONDS}"
        if (( now >= deadline )); then
            echo "Timed out waiting for ${CI_DQD_BUILDER} SSH on ${CI_DQD_SSH_HOST}:${CI_DQD_SSH_PORT}" >&2
            return 1
        fi
        sleep 3
    done
}

run_direct_ci() {
    make ci ENV="${ENV_DIR}"
}

ensure_ci_dqd_builder_image() {
    local builder_image builder_targets

    builder_image="$(image_from_compose "${CI_DQD_BUILDER}/docker-compose.yml")"
    if [[ -z "${builder_image}" ]]; then
        echo "Failed to detect image from ${CI_DQD_BUILDER}/docker-compose.yml" >&2
        exit 1
    fi

    if docker image inspect "${builder_image}" >/dev/null 2>&1; then
        return
    fi
    if docker pull "${builder_image}"; then
        return
    fi

    builder_targets="${CI_DQD_BUILDER_MAKE_TARGETS:-clean ctr vm dqd}"
    echo "Builder image ${builder_image} is unavailable; building ${CI_DQD_BUILDER} with targets '${builder_targets}'"
    make ci ENV="${CI_DQD_BUILDER}" CI_MAKE_TARGETS="${builder_targets}"

    if ! docker image inspect "${builder_image}" >/dev/null 2>&1; then
        docker pull "${builder_image}"
    fi
}

start_ci_dqd_env() {
    local compose_args

    compose_args=(-f "${CI_DQD_BUILDER}/docker-compose.yml")
    if [[ -e /dev/kvm && -f "${CI_DQD_BUILDER}/docker-compose.kvm.yml" ]]; then
        compose_args+=(-f "${CI_DQD_BUILDER}/docker-compose.kvm.yml")
    fi
    if [[ -n "${CI_DQD_QEMU_NET}" || -n "${CI_DQD_QEMU_DHCPSTART}" ]]; then
        CI_DQD_COMPOSE_OVERRIDE="$(mktemp -t dqd-ci-compose-XXXXXX.yml)"
        {
            printf '%s\n' 'services:'
            printf '%s\n' '  vm:'
            printf '%s\n' '    environment:'
            if [[ -n "${CI_DQD_QEMU_NET}" ]]; then
                printf '      QEMU_NET: "%s"\n' "${CI_DQD_QEMU_NET}"
            fi
            if [[ -n "${CI_DQD_QEMU_DHCPSTART}" ]]; then
                printf '      QEMU_DHCPSTART: "%s"\n' "${CI_DQD_QEMU_DHCPSTART}"
            fi
        } > "${CI_DQD_COMPOSE_OVERRIDE}"
        compose_args+=(-f "${CI_DQD_COMPOSE_OVERRIDE}")
    fi

    CI_DQD_COMPOSE_ARGS=("${compose_args[@]}")
    docker compose "${compose_args[@]}" up -d
    CI_DQD_STARTED=true
}

stop_ci_dqd_env() {
    if [[ "${CI_DQD_STARTED}" == "true" ]]; then
        docker compose "${CI_DQD_COMPOSE_ARGS[@]}" down || true
        CI_DQD_STARTED=false
    fi
    if [[ -n "${CI_DQD_COMPOSE_OVERRIDE}" ]]; then
        rm -f "${CI_DQD_COMPOSE_OVERRIDE}"
        CI_DQD_COMPOSE_OVERRIDE=""
    fi
}

sync_workspace() {
    local args

    mapfile -t args < <(ssh_args)
    ssh_in_dqd "rm -rf '${CI_DQD_WORKDIR}' && mkdir -p '${CI_DQD_WORKDIR}'"
    tar \
        --exclude=.git \
        --exclude=.claude \
        --exclude=.opencode \
        --exclude=.reasonix \
        --exclude='*.qcow2' \
        --exclude=modules \
        --exclude=node_modules \
        -cf - . |
        ssh "${args[@]}" "tar -C '${CI_DQD_WORKDIR}' -xf -"
}

prepare_ci_dqd_env() {
    ssh_in_dqd "CI_DQD_BUILDX_VERSION='${CI_DQD_BUILDX_VERSION}' bash -s" <<'EOF'
set -euo pipefail

if ! command -v docker >/dev/null 2>&1 || ! command -v make >/dev/null 2>&1; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl docker.io git make
fi

if ! docker buildx version >/dev/null 2>&1; then
    mkdir -p /usr/libexec/docker/cli-plugins /usr/local/lib/docker/cli-plugins
    docker buildx version >/dev/null 2>&1 || apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y docker-buildx-plugin || true
fi

if ! docker buildx version >/dev/null 2>&1; then
    mkdir -p /usr/local/lib/docker/cli-plugins /usr/libexec/docker/cli-plugins
    arch="$(uname -m)"
    case "${arch}" in
        x86_64) buildx_arch=amd64 ;;
        aarch64|arm64) buildx_arch=arm64 ;;
        *) echo "Unsupported architecture for docker buildx: ${arch}" >&2; exit 1 ;;
    esac
    curl -fsSL \
        "https://github.com/docker/buildx/releases/download/${CI_DQD_BUILDX_VERSION}/buildx-${CI_DQD_BUILDX_VERSION}.linux-${buildx_arch}" \
        -o /usr/local/lib/docker/cli-plugins/docker-buildx
    chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx
    ln -sf /usr/local/lib/docker/cli-plugins/docker-buildx /usr/libexec/docker/cli-plugins/docker-buildx
fi

systemctl start docker || service docker start
docker buildx version
test "$(stat -fc %T /sys/fs/cgroup)" = "tmpfs"
EOF
}

login_to_ghcr_inside_dqd() {
    local args

    if [[ -z "${GITHUB_ACTOR:-}" || -z "${GITHUB_TOKEN:-}" ]]; then
        return 0
    fi

    mapfile -t args < <(ssh_args)
    printf '%s' "${GITHUB_TOKEN}" |
        ssh "${args[@]}" "docker login '${REGISTRY}' -u '${GITHUB_ACTOR}' --password-stdin"
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
trap stop_ci_dqd_env EXIT
run_nested_ci
