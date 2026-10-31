# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=buildx-0-38-1
ARG VERSION_BUILDX=0.38.1
ARG IMAGE_DOCKER=ghcr.io/ctrsploit/docker-v29.7.2
ARG VERSION_IMAGE=0.1.0

# ================================
# Internal Variables
# ================================
ARG URL_ARTIFACT_BUILDX=https://github.com/docker/buildx/releases/download/v${VERSION_BUILDX}/buildx-v${VERSION_BUILDX}.linux-amd64
ARG BASE_IMAGE=${IMAGE_DOCKER}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG URL_ARTIFACT_BUILDX
# upgrade the buildx CLI plugin (the base image ships the plugin at this path)
ADD ${URL_ARTIFACT_BUILDX} /tmp/buildx
RUN install -m 755 /tmp/buildx /usr/libexec/docker/cli-plugins/docker-buildx && rm /tmp/buildx
# install gcc
RUN apt-get update && apt-get install -y gcc && apt-get clean -y && rm -rf /var/lib/apt/lists/*
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname
