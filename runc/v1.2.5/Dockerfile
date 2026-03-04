# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=runc-1-2-5
ARG VERSION_RUNC=1.2.5
ARG VERSION_UBUNTU=24.04
ARG VERSION_IMAGE_UBUNTU=0.4.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_UBUNTU=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_${VERSION_IMAGE_UBUNTU}
ARG URL_ARTIFACT_RUNC=https://github.com/opencontainers/runc/releases/download/v${VERSION_RUNC}/runc.amd64

# ================================
# Build Stages
# ================================
FROM ${IMAGE_UBUNTU}
ARG HOSTNAME
ARG URL_ARTIFACT_RUNC
RUN apt update && apt install -y busybox-static && apt-get clean -y && rm -rf /var/lib/apt/lists/*
ADD ${URL_ARTIFACT_RUNC} /tmp/runc.amd64
RUN install -m 755 /tmp/runc.amd64 /usr/local/sbin/runc && rm /tmp/runc.amd64
RUN echo "${HOSTNAME}" > /etc/hostname
