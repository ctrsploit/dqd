# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=ubuntu12-04
ARG VERSION_UBUNTU=12.04
ARG SSH_PASSWORD=root
ARG SSH_PUB_KEY='ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIzH7+rSfx12KuhxvF8Zl/0IFWUKI3iX8alPP9UCX2vkw3E7FY+PY2e4UFnqNNYbqzVvqkA1g9reSIm6bc334LM= default@dqd'

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ubuntu:${VERSION_UBUNTU}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE} AS build
ARG SSH_PASSWORD
ARG SSH_PUB_KEY

# apt sources
RUN sed -i 's/archive/old-releases/g' /etc/apt/sources.list

# install packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y xterm vim openssh-server && \
  rm -rf /var/lib/apt/lists/* && \
  echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# password
RUN echo "root:${SSH_PASSWORD}" | chpasswd && \
  mkdir -p /root/.ssh/ && \
  echo "${SSH_PUB_KEY}" >> /root/.ssh/authorized_keys

ARG HOSTNAME
RUN echo "${HOSTNAME}" > /etc/hostname
