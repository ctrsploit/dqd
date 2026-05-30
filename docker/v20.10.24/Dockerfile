# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-20-10-24
ARG VERSION_DOCKER=20.10.24
# https://github.com/moby/moby/blob/v20.10.24/hack/dockerfile/install/containerd.installer#L18
ARG VERSION_CONTAINERD_IO=1.6.16
ARG VERSION_UBUNTU=22.04
ARG VERSION_IMAGE=0.3.0

# ================================
# Internal Variables
# ================================
ARG VERSION_PKG_DOCKER=5:${VERSION_DOCKER}~3-0~ubuntu-jammy
ARG VERSION_PKG_CONTAINERD_IO=${VERSION_CONTAINERD_IO}-1
ARG VERSION_PKG_COMPOSE=2.17.2-1~ubuntu.22.04~jammy
ARG VERSION_PKG_BUILDX=0.10.4-1~ubuntu.22.04~jammy
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_PKG_DOCKER
ARG VERSION_PKG_CONTAINERD_IO
ARG VERSION_PKG_COMPOSE
ARG VERSION_PKG_BUILDX
# Add Docker's official GPG key; Add the repository to Apt sources:
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null 

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-ce=${VERSION_PKG_DOCKER} \
    docker-ce-cli=${VERSION_PKG_DOCKER} \
    containerd.io=${VERSION_PKG_CONTAINERD_IO} \
    docker-compose-plugin=${VERSION_PKG_COMPOSE} \
    docker-buildx-plugin=${VERSION_PKG_BUILDX}

RUN echo "${HOSTNAME}" > /etc/hostname
