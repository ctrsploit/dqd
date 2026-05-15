# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=runc-0-0-8
ARG VERSION_RUNC=0.0.8
ARG VERSION_UBUNTU=16.04
ARG VERSION_IMAGE_UBUNTU=0.3.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_UBUNTU=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE_UBUNTU}
ARG URL_ARTIFACT_RUNC=https://github.com/ssst0n3/container-debug-artifacts/releases/download/runc/runc-v${VERSION_RUNC}-debug

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
