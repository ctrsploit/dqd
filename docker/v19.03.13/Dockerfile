# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-19-03-13
ARG VERSION_DOCKER=19.03.13
ARG VERSION_CONTAINERD_IO=1.3.7
ARG VERSION_UBUNTU=20.04
ARG VERSION_IMAGE=0.3.0

# ================================
# Internal Variables
# ================================
ARG VERSION_PKG_DOCKER=5:${VERSION_DOCKER}~3-0~ubuntu-focal
ARG VERSION_PKG_CONTAINERD_IO=${VERSION_CONTAINERD_IO}-1
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_PKG_DOCKER
ARG VERSION_PKG_CONTAINERD_IO
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
    containerd.io=${VERSION_PKG_CONTAINERD_IO}

RUN echo "${HOSTNAME}" > /etc/hostname
