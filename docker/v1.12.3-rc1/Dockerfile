# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-1-12-3-rc1
ARG VERSION_DOCKER=1.12.3-rc1
ARG VERSION_UBUNTU=16.04
ARG VERSION_IMAGE=0.3.0

# ================================
# Internal Variables
# ================================
ARG URL_ARTIFACT_DOCKER=https://github.com/ssst0n3/container-debug-artifacts/releases/download/docker
ARG URL_ARTIFACT_SYSTEMD=https://raw.githubusercontent.com/moby/moby/refs/tags/v${VERSION_DOCKER}/contrib/init/systemd
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_ARTIFACT_DOCKER
ARG URL_ARTIFACT_SYSTEMD
ARG VERSION_DOCKER
# install docker bins
ADD --chmod=755 ${URL_ARTIFACT_DOCKER}/dockerd-v${VERSION_DOCKER}-debug /usr/bin/dockerd
ADD --chmod=755 ${URL_ARTIFACT_DOCKER}/docker-v${VERSION_DOCKER}-debug /usr/bin/docker
ADD --chmod=755 ${URL_ARTIFACT_DOCKER}/docker-containerd-v${VERSION_DOCKER}-debug /usr/bin/docker-containerd
ADD --chmod=755 ${URL_ARTIFACT_DOCKER}/docker-containerd-shim-v${VERSION_DOCKER}-debug /usr/bin/docker-containerd-shim
ADD --chmod=755 ${URL_ARTIFACT_DOCKER}/docker-containerd-ctr-v${VERSION_DOCKER}-debug /usr/bin/docker-containerd-ctr
ADD --chmod=755 ${URL_ARTIFACT_DOCKER}/docker-runc-v${VERSION_DOCKER}-debug /usr/bin/docker-runc
ADD --chmod=755 ${URL_ARTIFACT_DOCKER}/docker-proxy-v${VERSION_DOCKER}-debug /usr/bin/docker-proxy
# install systemd services
ADD ${URL_ARTIFACT_SYSTEMD}/docker.service /usr/local/lib/systemd/system/docker.service
ADD ${URL_ARTIFACT_SYSTEMD}/docker.socket /usr/local/lib/systemd/system/docker.socket
RUN groupadd --system docker && \
    systemctl enable docker.service
# install dependencies
RUN apt update && apt install -y iptables
RUN echo "${HOSTNAME}" > /etc/hostname
