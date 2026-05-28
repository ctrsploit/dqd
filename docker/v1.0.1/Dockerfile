# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-1-0-1
ARG VERSION_DOCKER=1.0.1
ARG VERSION_UBUNTU=14.04
ARG VERSION_IMAGE=0.2.0

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}
ARG URL_ARTIFACT_DOCKER=http://launchpadlibrarian.net/182886743/docker.io_1.0.1~dfsg1-0ubuntu1~ubuntu0.14.04.1_amd64.deb

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_DOCKER
ARG URL_ARTIFACT_DOCKER
ADD ${URL_ARTIFACT_DOCKER} /tmp/docker.io.deb
RUN dpkg -i /tmp/docker.io.deb || echo 'pass'
# install dependencies
RUN apt-get update && apt-get install -f -y
RUN echo "${HOSTNAME}" > /etc/hostname
