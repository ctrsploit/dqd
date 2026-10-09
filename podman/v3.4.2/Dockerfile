# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=podman-3-4-2
ARG VERSION_PODMAN=3.4.2
ARG VERSION_IMAGE_UBUNTU=0.3.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_UBUNTU=ghcr.io/ctrsploit/ubuntu-20.04:ctr_v${VERSION_IMAGE_UBUNTU}
ARG URL_KUBIC_GPG=https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key

# ================================
# Build Stages
# ================================
FROM ${IMAGE_UBUNTU}
ARG HOSTNAME
ARG URL_KUBIC_GPG
# podman 3.4.2 from the kubic repository (runc-rc93 era, 2021)
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg && \
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" \
      > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && \
    curl -fsSL "${URL_KUBIC_GPG}" | apt-key add - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      podman=100:3.4.2-5 conmon containernetworking-plugins && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "${HOSTNAME}" > /etc/hostname
