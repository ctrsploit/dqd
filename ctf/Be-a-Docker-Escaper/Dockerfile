# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=be-a-docker-escaper
ARG FLAG=rwctf{THIS_IS_A_TEST_FLAG}
ARG VERSION_UBUNTU=24.04
ARG VERSION_IMAGE=0.4.0

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE} AS base
RUN apt update && \
    apt install -y docker.io && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

FROM base AS user
RUN useradd -m -s /home/ctf/run.sh -G docker ctf && \
    echo "ctf:ctf" | chpasswd
RUN printf '#!/bin/bash\ndocker run -ti -m 128m -v /var/run/docker.sock:/s busybox:latest # You are here!' > /home/ctf/run.sh && \
    chmod +x /home/ctf/run.sh

FROM user AS final
ARG HOSTNAME
ARG FLAG
RUN echo ${HOSTNAME} > /etc/hostname && \
    echo ${FLAG} > /root/flag
