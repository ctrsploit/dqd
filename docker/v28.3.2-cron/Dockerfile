# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-28-3-2-cron
ARG VERSION_DOCKER=28.3.2
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
RUN apt update && \
    apt install -y cron && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo ${HOSTNAME} > /etc/hostname
