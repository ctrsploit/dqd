# ================================
# CONFIG: version pins
# ================================
ARG HOSTNAME=nerdctl-2-1-2-apparmor
ARG VERSION_NERDCTL=2.1.2
ARG VERSION_IMAGE_NERDCTL=0.1.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_NERDCTL=ghcr.io/ctrsploit/nerdctl-v${VERSION_NERDCTL}

# ================================
# Build Stages
# ================================
FROM ${IMAGE_NERDCTL}:ctr_v${VERSION_IMAGE_NERDCTL}
ARG HOSTNAME
RUN apt update && \
    apt install -y apparmor && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "${HOSTNAME}" > /etc/hostname
