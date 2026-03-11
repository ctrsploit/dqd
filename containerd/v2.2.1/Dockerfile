# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=containerd-2-2-1
ARG VERSION_CONTAINERD=2.2.1
# https://github.com/containerd/containerd/blob/v2.2.1/script/setup/runc-version
ARG VERSION_RUNC=1.3.4
ARG VERSION_IMAGE_RUNC=0.2.0

# ================================
# Internal Variables
# ================================
ARG URL_ARTIFACT_CONTAINERD=https://github.com/containerd/containerd/releases/download/v${VERSION_CONTAINERD}/containerd-${VERSION_CONTAINERD}-linux-amd64.tar.gz
ARG URL_ARTIFACT_SYSTEMD=https://raw.githubusercontent.com/containerd/containerd/refs/tags/v${VERSION_CONTAINERD}/containerd.service
ARG BASE_IMAGE=ghcr.io/ctrsploit/runc-v${VERSION_RUNC}:ctr_v${VERSION_IMAGE_RUNC}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_ARTIFACT_CONTAINERD
ARG URL_ARTIFACT_SYSTEMD
# install containerd
ADD ${URL_ARTIFACT_CONTAINERD} /tmp/containerd.tar.gz
RUN tar Cxzvf /usr/local /tmp/containerd.tar.gz \
    && rm /tmp/containerd.tar.gz
# config systemd
ADD ${URL_ARTIFACT_SYSTEMD} /usr/local/lib/systemd/system/containerd.service
RUN echo "${HOSTNAME}" > /etc/hostname
