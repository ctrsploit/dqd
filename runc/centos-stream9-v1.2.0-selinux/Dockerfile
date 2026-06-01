# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=runc-centos-stream9-v1-2-0-selinux
ARG VERSION_RUNC=1.2.0
ARG VERSION_IMAGE=0.1.0

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/centos-stream9-runc-v${VERSION_RUNC}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
RUN dnf install -y \
    selinux-policy \
    selinux-policy-targeted \
    policycoreutils \
    policycoreutils-python-utils && \
    dnf clean all && \
    rm -rf /var/cache/dnf/* && \
    touch /.autorelabel
RUN echo "${HOSTNAME}" > /etc/hostname
