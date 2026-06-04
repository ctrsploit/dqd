# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=cgroup-v1-builder
ARG VERSION_IMAGE_UBUNTU=0.3.0
ARG VERSION_BUILDX=0.14.1

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-20.04:ctr_v${VERSION_IMAGE_UBUNTU}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_BUILDX

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        ca-certificates \
        curl \
        docker.io \
        git \
        make && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    arch="$(uname -m)"; \
    case "${arch}" in \
        x86_64) buildx_arch=amd64 ;; \
        aarch64|arm64) buildx_arch=arm64 ;; \
        *) echo "Unsupported architecture for docker buildx: ${arch}" >&2; exit 1 ;; \
    esac; \
    mkdir -p /usr/local/lib/docker/cli-plugins /usr/libexec/docker/cli-plugins; \
    curl -fsSL \
        "https://github.com/docker/buildx/releases/download/v${VERSION_BUILDX}/buildx-v${VERSION_BUILDX}.linux-${buildx_arch}" \
        -o /usr/local/lib/docker/cli-plugins/docker-buildx; \
    chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx; \
    ln -sf /usr/local/lib/docker/cli-plugins/docker-buildx /usr/libexec/docker/cli-plugins/docker-buildx

RUN echo "${HOSTNAME}" > /etc/hostname
