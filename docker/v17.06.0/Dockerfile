# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-17-06-0
ARG VERSION_PKG_DOCKER=17.06.0~ce-0~ubuntu
ARG VERSION_UBUNTU=16.04
ARG VERSION_IMAGE=0.3.0

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_PKG_DOCKER
# Add Docker's official GPG key; Add the repository to Apt sources:
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null 

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-ce=${VERSION_PKG_DOCKER}

RUN echo "${HOSTNAME}" > /etc/hostname
