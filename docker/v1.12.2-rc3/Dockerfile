# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-1-12-2-rc3
ARG VERSION_DOCKER=1.12.2-rc3
ARG VERSION_UBUNTU=16.04
ARG VERSION_IMAGE=0.3.0

# ================================
# Internal Variables
# ================================
ARG URL_ARTIFACT_SYSTEMD=https://raw.githubusercontent.com/moby/moby/refs/tags/v${VERSION_DOCKER}/contrib/init/systemd
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM docker:${VERSION_DOCKER} AS docker_bins

FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_ARTIFACT_SYSTEMD
# install docker bins
COPY --chmod=755 --from=docker_bins /usr/local/bin/* /usr/bin/
# install systemd services
ADD ${URL_ARTIFACT_SYSTEMD}/docker.service /usr/local/lib/systemd/system/docker.service
ADD ${URL_ARTIFACT_SYSTEMD}/docker.socket /usr/local/lib/systemd/system/docker.socket
RUN groupadd --system docker && \
    systemctl enable docker.service
# install dependencies
RUN apt update && apt install -y iptables
RUN echo "${HOSTNAME}" > /etc/hostname
