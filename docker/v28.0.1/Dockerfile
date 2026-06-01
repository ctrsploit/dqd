# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-28-0-1
ARG VERSION_DOCKER=28.0.1
# https://github.com/moby/moby/blob/v28.0.1/Dockerfile#L205
ARG VERSION_CONTAINERD=1.7.25
# https://github.com/moby/moby/blob/v28.0.1/Dockerfile#L18
ARG VERSION_BUILDX=0.20.1
# https://github.com/moby/moby/blob/v28.0.1/Dockerfile#L19
ARG VERSION_COMPOSE=2.32.4
ARG VERSION_UBUNTU=24.04
ARG VERSION_IMAGE=0.4.0

# ================================
# Internal Variables
# ================================
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
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    printf "%s\n" \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") test" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null 

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-ce=5:${VERSION_DOCKER}-1~ubuntu.24.04~noble \
    docker-ce-cli=5:${VERSION_DOCKER}-1~ubuntu.24.04~noble \
    containerd.io=${VERSION_CONTAINERD}-1 \
    docker-buildx-plugin=${VERSION_BUILDX}-1~ubuntu.24.04~noble \
    docker-compose-plugin=${VERSION_COMPOSE}-1~ubuntu.24.04~noble

RUN echo "${HOSTNAME}" > /etc/hostname
