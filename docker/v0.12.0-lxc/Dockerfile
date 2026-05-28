# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=docker-0-12-0-lxc
ARG VERSION_DOCKER=0.12.0
ARG VERSION_UBUNTU=14.04
ARG VERSION_IMAGE=0.2.0

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}
ARG URL_ARTIFACT_DOCKER=http://get.docker.io/ubuntu/pool/main/l/lxc-docker-${VERSION_DOCKER}/lxc-docker-${VERSION_DOCKER}_${VERSION_DOCKER}_amd64.deb

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_DOCKER
ARG URL_ARTIFACT_DOCKER
ADD ${URL_ARTIFACT_DOCKER} /tmp/
RUN dpkg -i /tmp/lxc-docker-${VERSION_DOCKER}_${VERSION_DOCKER}_amd64.deb || echo 'pass'
# install dependencies
RUN apt-get update && apt-get install -f -y
# install apparmor, lxc
RUN apt-get update && apt-get install -y apparmor lxc net-tools
RUN sed -i 's/DOCKER_OPTS=/DOCKER_OPTS="-e lxc"/g' /etc/init/docker.conf
RUN echo "${HOSTNAME}" > /etc/hostname
