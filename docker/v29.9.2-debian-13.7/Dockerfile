# ============================================================================
# Configuration variables
# ============================================================================
ARG HOSTNAME=docker-29-9-2-debian-13-7
ARG VERSION_DOCKER=29.9.2
# https://github.com/moby/moby/blob/docker-v29.9.2/Dockerfile
ARG VERSION_CONTAINERD=2.4.2
ARG VERSION_BUILDX=0.38.0
ARG VERSION_COMPOSE=5.6.0
ARG VERSION_DEBIAN=13.7

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/debian-${VERSION_DEBIAN}:ctr_v0.1.0
ARG URL_DOCKER_REPO_KEY=https://download.docker.com/linux/debian/gpg
ARG URL_DOCKER_REPO=https://download.docker.com/linux/debian
ARG VERSION_PKG_DOCKER=5:${VERSION_DOCKER}-1~debian.13~trixie
ARG VERSION_PKG_CONTAINERD=${VERSION_CONTAINERD}-3~debian.13~trixie
ARG VERSION_PKG_BUILDX=${VERSION_BUILDX}-1~debian.13~trixie
ARG VERSION_PKG_COMPOSE=${VERSION_COMPOSE}-1~debian.13~trixie

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_DOCKER_REPO_KEY
ARG URL_DOCKER_REPO
ARG VERSION_PKG_DOCKER
ARG VERSION_PKG_CONTAINERD
ARG VERSION_PKG_BUILDX
ARG VERSION_PKG_COMPOSE
# Add Docker's official GPG key; Add the repository to Apt sources:
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL ${URL_DOCKER_REPO_KEY} -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] ${URL_DOCKER_REPO} \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-ce=${VERSION_PKG_DOCKER} \
    docker-ce-cli=${VERSION_PKG_DOCKER} \
    containerd.io=${VERSION_PKG_CONTAINERD} \
    docker-buildx-plugin=${VERSION_PKG_BUILDX} \
    docker-compose-plugin=${VERSION_PKG_COMPOSE}
RUN echo "${HOSTNAME}" > /etc/hostname
