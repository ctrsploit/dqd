# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=podman-5-4-0
ARG VERSION_PODMAN=5.4.0
ARG VERSION_PODMAN_RELEASE=5.el9
ARG VERSION_CENTOS=stream9
ARG VERSION_IMAGE=0.2.0
ARG URL_ARTIFACT_PODMAN=https://kojihub.stream.centos.org/kojifiles/packages/podman/${VERSION_PODMAN}/${VERSION_PODMAN_RELEASE}/x86_64/podman-${VERSION_PODMAN}-${VERSION_PODMAN_RELEASE}.x86_64.rpm

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/centos-${VERSION_CENTOS}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE} AS podman
ARG URL_ARTIFACT_PODMAN
RUN dnf -y install \
    ${URL_ARTIFACT_PODMAN} && \
    dnf clean all

FROM podman AS rootless
ARG HOSTNAME
# Enable writing /proc/[pid]/uid_map and /proc/[pid]/gid_map for rootless podman.
RUN chmod 4755 /usr/bin/newuidmap /usr/bin/newgidmap
RUN useradd -m -U -d /home/user -s /bin/bash user
RUN mkdir -p /var/lib/systemd/linger && \
    touch /var/lib/systemd/linger/user && \
    chmod 644 /var/lib/systemd/linger/user
RUN echo ${HOSTNAME} > /etc/hostname
