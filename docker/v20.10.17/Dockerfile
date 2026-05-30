# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-20-10-17
ARG VERSION_DOCKER=20.10.17
# https://github.com/moby/moby/blob/v20.10.17/hack/dockerfile/install/containerd.installer#L18
ARG VERSION_CONTAINERD=1.6.6
ARG VERSION_UBUNTU=22.04
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
ARG VERSION_DOCKER
ARG VERSION_CONTAINERD
# Add Docker's official GPG key; Add the repository to Apt sources:
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
    docker-ce=5:${VERSION_DOCKER}~3-0~ubuntu-jammy \
    docker-ce-cli=5:${VERSION_DOCKER}~3-0~ubuntu-jammy \
    containerd.io=${VERSION_CONTAINERD}-1

RUN echo "${HOSTNAME}" > /etc/hostname
