# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=podman-5-4-0
ARG VERSION_PODMAN=5.4.0
ARG VERSION_PODMAN_RELEASE=5.el9
ARG VERSION_CENTOS=stream9
ARG VERSION_KERNEL=5.14.0-601.el9.x86_64
ARG VERSION_KERNEL_UPSTREAM=5.14.0
ARG VERSION_KERNEL_RELEASE=601.el9
ARG VERSION_IMAGE=0.2.0
ARG URL_ARTIFACT_PODMAN=https://kojihub.stream.centos.org/kojifiles/packages/podman/${VERSION_PODMAN}/${VERSION_PODMAN_RELEASE}/x86_64/podman-${VERSION_PODMAN}-${VERSION_PODMAN_RELEASE}.x86_64.rpm
ARG URL_ARTIFACT_KERNEL_CORE=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-core-${VERSION_KERNEL}.rpm
ARG URL_ARTIFACT_KERNEL_MODULES_CORE=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-modules-core-${VERSION_KERNEL}.rpm
ARG URL_ARTIFACT_KERNEL_MODULES=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-modules-${VERSION_KERNEL}.rpm
ARG URL_ARTIFACT_KERNEL=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-${VERSION_KERNEL}.rpm

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/centos-${VERSION_CENTOS}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE} AS podman
ARG URL_ARTIFACT_PODMAN
ARG URL_ARTIFACT_KERNEL_CORE
ARG URL_ARTIFACT_KERNEL_MODULES_CORE
ARG URL_ARTIFACT_KERNEL_MODULES
ARG URL_ARTIFACT_KERNEL
RUN mkdir -p /etc/dracut.conf.d && \
    printf "hostonly=no\n" > /etc/dracut.conf.d/99-dqd.conf
RUN dnf -y install --setopt=install_weak_deps=False \
    ${URL_ARTIFACT_PODMAN} \
    ${URL_ARTIFACT_KERNEL_CORE} \
    ${URL_ARTIFACT_KERNEL_MODULES_CORE} \
    ${URL_ARTIFACT_KERNEL_MODULES} \
    ${URL_ARTIFACT_KERNEL} && \
    dnf clean all

FROM podman AS rootless
ARG HOSTNAME
ARG VERSION_KERNEL
# Enable writing /proc/[pid]/uid_map and /proc/[pid]/gid_map for rootless podman.
RUN chmod 4755 /usr/bin/newuidmap /usr/bin/newgidmap
RUN useradd -m -U -d /home/user -s /bin/bash user
RUN mkdir -p /var/lib/systemd/linger && \
    touch /var/lib/systemd/linger/user && \
    chmod 644 /var/lib/systemd/linger/user
RUN echo ${HOSTNAME} > /etc/hostname
RUN set -eux; \
    mkdir -p /boot; \
    if [ ! -f "/boot/vmlinuz-${VERSION_KERNEL}" ]; then \
        cp -f "/usr/lib/modules/${VERSION_KERNEL}/vmlinuz" "/boot/vmlinuz-${VERSION_KERNEL}"; \
    fi; \
    if [ ! -f "/boot/initramfs-${VERSION_KERNEL}.img" ]; then \
        dracut --no-hostonly --force "/boot/initramfs-${VERSION_KERNEL}.img" "${VERSION_KERNEL}"; \
    fi; \
    test -f "/boot/vmlinuz-${VERSION_KERNEL}"; \
    test -f "/boot/initramfs-${VERSION_KERNEL}.img"
