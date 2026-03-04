# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=ubuntu24-04
ARG VERSION_UBUNTU=24.04
ARG SSH_PASSWORD=root
ARG SSH_PUB_KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtOfmNu0t6Z3bEg47tdMkTNZdv7+Fd3KWTD0xNk5Woe default@dqd'

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

# install common packages
RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -y xterm vim jq && \
  rm -rf /var/lib/apt/lists/*

# ssh
RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -y openssh-server && \
  rm -rf /var/lib/apt/lists/* && \
  echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# password
RUN echo root:root | chpasswd && \
  echo ${SSH_PUB_KEY} >> /root/.ssh/authorized_keys

ARG HOSTNAME
RUN echo "${HOSTNAME}" > /etc/hostname
