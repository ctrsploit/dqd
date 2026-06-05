# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-compose-2-40-0
ARG VERSION_COMPOSE=2.40.0
ARG VERSION_COMPOSE_PACKAGE=1~ubuntu.24.04~noble
ARG VERSION_DOCKER=28.3.2
ARG VERSION_IMAGE=0.1.0

# ================================
# Internal Variables
# ================================
ARG PACKAGE_COMPOSE=${VERSION_COMPOSE}-${VERSION_COMPOSE_PACKAGE}
ARG BASE_IMAGE=ghcr.io/ctrsploit/docker-v${VERSION_DOCKER}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG PACKAGE_COMPOSE
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-compose-plugin=${PACKAGE_COMPOSE} && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo ${HOSTNAME} > /etc/hostname
