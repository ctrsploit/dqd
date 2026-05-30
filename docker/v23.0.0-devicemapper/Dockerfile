# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-23-0-0-devicemapper
ARG VERSION_DOCKER=23.0.0
ARG VERSION_IMAGE=0.1.0

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/docker-v${VERSION_DOCKER}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
RUN mkdir -p /etc/docker && \
    echo '{"storage-driver": "devicemapper"}' > /etc/docker/daemon.json && \
    echo ${HOSTNAME} > /etc/hostname
