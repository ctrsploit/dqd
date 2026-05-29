# ============================================================================
# Configuration variables
# ============================================================================
ARG HOSTNAME=docker-29-5-2
ARG VERSION_DOCKER=29.5.2
# https://github.com/moby/moby/blob/docker-v29.5.2/Dockerfile#L145
ARG VERSION_CONTAINERD=2.2.3
# https://github.com/moby/moby/blob/docker-v29.5.2/Dockerfile#L20
ARG VERSION_BUILDX=0.34.1
# https://github.com/moby/moby/blob/docker-v29.5.2/Dockerfile#L23
ARG VERSION_COMPOSE=5.1.3
ARG VERSION_UBUNTU=24.04
ARG VERSION_IMAGE=0.4.0

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_DOCKER
ARG VERSION_CONTAINERD
ARG VERSION_BUILDX
ARG VERSION_COMPOSE
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
    docker-ce=5:${VERSION_DOCKER}-1~ubuntu.24.04~noble \
    docker-ce-cli=5:${VERSION_DOCKER}-1~ubuntu.24.04~noble \
    containerd.io=${VERSION_CONTAINERD}-1~ubuntu.24.04~noble \
    docker-buildx-plugin=${VERSION_BUILDX}-1~ubuntu.24.04~noble \
    docker-compose-plugin=${VERSION_COMPOSE}-1~ubuntu.24.04~noble
RUN echo "${HOSTNAME}" > /etc/hostname
