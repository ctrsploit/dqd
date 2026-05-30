ARG HOSTNAME=docker-29-5-2-criu
ARG VERSION_UBUNTU=24.04
ARG VERSION_BASE_IMAGE=0.1.0
ARG CRIU_REPO=https://download.opensuse.org/repositories/devel:/tools:/criu/xUbuntu_${VERSION_UBUNTU}
ARG KEYFILE=/usr/share/keyrings/criu-repo-keyring.gpg
ARG BASE_IMAGE=ghcr.io/ctrsploit/docker-v29.5.2:ctr_v${VERSION_BASE_IMAGE}

FROM ${BASE_IMAGE}
ARG CRIU_REPO
ARG KEYFILE
ARG HOSTNAME
RUN apt update && \
    apt install -y gpg xz-utils && \
    wget -nv $CRIU_REPO/Release.key -O- | gpg --dearmor > "$KEYFILE" && \
    echo "deb [signed-by=$KEYFILE] $CRIU_REPO/ /" > /etc/apt/sources.list.d/criu.list && \
    apt update && \
    apt install -y criu iptables && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN echo "${HOSTNAME}" > /etc/hostname
