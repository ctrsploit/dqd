# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=fedora-45
ARG VERSION_FEDORA=45
ARG SSH_PASSWORD=root
ARG SSH_PUB_KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtOfmNu0t6Z3bEg47tdMkTNZdv7+Fd3KWTD0xNk5Woe default@dqd'

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=fedora:${VERSION_FEDORA}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE} AS build
ARG SSH_PASSWORD
ARG SSH_PUB_KEY

# install common packages
RUN dnf install -y xterm vim jq openssh-server && \
    dnf clean all

# ssh
RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# password
RUN echo "root:${SSH_PASSWORD}" | chpasswd && \
    mkdir -p /root/.ssh && \
    echo "${SSH_PUB_KEY}" >> /root/.ssh/authorized_keys

ARG HOSTNAME
RUN echo "${HOSTNAME}" > /etc/hostname
