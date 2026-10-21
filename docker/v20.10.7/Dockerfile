# ============================================================================
# Configuration variables
# ============================================================================
ARG HOSTNAME=docker-20-10-7
ARG VERSION_DOCKER=20.10.7
# The June-2021 security snapshot: containerd.io 1.4.6 ships /usr/bin/runc
# v1.0.0-rc95 -- the FIXED runtime for CVE-2021-30465, released together with
# docker 20.10.7 to replace the vulnerable rc93 bundled by containerd.io 1.4.4.
ARG VERSION_CONTAINERD=1.4.6
ARG VERSION_UBUNTU=20.04
ARG VERSION_IMAGE=0.3.0

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

# Add Docker's official GPG key and apt repository for historical packages.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    printf '%s\n' "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install the exact docker 20.10.7 release (runc v1.0.0-rc95 bundled).
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    docker-ce=5:${VERSION_DOCKER}~3-0~ubuntu-focal \
    docker-ce-cli=5:${VERSION_DOCKER}~3-0~ubuntu-focal \
    containerd.io=${VERSION_CONTAINERD}-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo "${HOSTNAME}" > /etc/hostname
