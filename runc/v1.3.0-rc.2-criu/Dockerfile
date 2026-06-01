# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=runc-1-3-0-rc-2-criu
ARG VERSION_RUNC=1.3.0-rc.2
ARG VERSION_UBUNTU=24.04
ARG VERSION_IMAGE=0.1.0

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/runc-v${VERSION_RUNC}:ctr_v${VERSION_IMAGE}
ARG CRIU_REPO=https://download.opensuse.org/repositories/devel:/tools:/criu/xUbuntu_${VERSION_UBUNTU}
ARG KEYFILE=/usr/share/keyrings/criu-repo-keyring.gpg

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG CRIU_REPO
ARG KEYFILE
RUN apt update && \
    apt install -y gpg xz-utils && \
    wget -nv $CRIU_REPO/Release.key -O- | gpg --dearmor > "$KEYFILE" && \
    echo "deb [signed-by=$KEYFILE] $CRIU_REPO/ /" > /etc/apt/sources.list.d/criu.list && \
    apt update && \
    apt install -y criu iptables && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN echo "${HOSTNAME}" > /etc/hostname
