# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=runc-ubuntu-20-04-v1-1-9
ARG VERSION_RUNC=1.1.9
ARG VERSION_UBUNTU=20.04
ARG VERSION_IMAGE=0.3.0

# ================================
# Internal Variables
# ================================
ARG URL_ARTIFACT_RUNC=https://github.com/opencontainers/runc/releases/download/v${VERSION_RUNC}/runc.amd64
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_ARTIFACT_RUNC
RUN apt update && apt install -y busybox-static && apt-get clean -y && rm -rf /var/lib/apt/lists/*
ADD ${URL_ARTIFACT_RUNC} /tmp/runc.amd64
RUN install -m 755 /tmp/runc.amd64 /usr/local/sbin/runc && rm /tmp/runc.amd64
RUN echo "${HOSTNAME}" > /etc/hostname
