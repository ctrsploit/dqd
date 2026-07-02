# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=nvidia-container-toolkit-1-17-6-podman-5-5-1
ARG VERSION_NCT=1.17.6
ARG VERSION_NCT_PKG=${VERSION_NCT}-1
ARG VERSION_FAKE_NVIDIA=0.7.3-rc.2
ARG VERSION_PODMAN=5.5.1
ARG VERSION_KERNEL=5.14.0-601.el9.x86_64
ARG VERSION_KERNEL_UPSTREAM=5.14.0
ARG VERSION_KERNEL_RELEASE=601.el9
ARG VERSION_NVIDIA_DRIVER=575.57.08
ARG VERSION_IMAGE=0.1.0
ARG URL_ARTIFACT_FAKE=https://github.com/ssst0n3/fake-nvidia/archive/refs/tags/v${VERSION_FAKE_NVIDIA}.tar.gz
ARG URL_ARTIFACT_DRIVER=https://us.download.nvidia.com/tesla/${VERSION_NVIDIA_DRIVER}/NVIDIA-Linux-x86_64-${VERSION_NVIDIA_DRIVER}.run
ARG URL_ARTIFACT_KERNEL_CORE=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-core-${VERSION_KERNEL}.rpm
ARG URL_ARTIFACT_KERNEL_MODULES_CORE=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-modules-core-${VERSION_KERNEL}.rpm
ARG URL_ARTIFACT_KERNEL_MODULES=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-modules-${VERSION_KERNEL}.rpm
ARG URL_ARTIFACT_KERNEL=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-${VERSION_KERNEL}.rpm
ARG URL_ARTIFACT_KERNEL_DEVEL=https://kojihub.stream.centos.org/kojifiles/packages/kernel/${VERSION_KERNEL_UPSTREAM}/${VERSION_KERNEL_RELEASE}/x86_64/kernel-devel-${VERSION_KERNEL}.rpm

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/podman-v${VERSION_PODMAN}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
# https://gitlab.com/nvidia/container-images/driver/-/blob/master/ubuntu18.04/Dockerfile#L48
FROM ${BASE_IMAGE} AS driver
ARG URL_ARTIFACT_DRIVER
ADD --chmod=755 ${URL_ARTIFACT_DRIVER} /tmp/nvidia-driver.run
RUN /tmp/nvidia-driver.run --silent \
    --no-kernel-module \
    --install-compat32-libs

FROM driver AS fake-nvidia
ARG VERSION_FAKE_NVIDIA
ARG VERSION_KERNEL
ARG VERSION_NVIDIA_DRIVER
ARG URL_ARTIFACT_FAKE
ARG URL_ARTIFACT_KERNEL_CORE
ARG URL_ARTIFACT_KERNEL_MODULES_CORE
ARG URL_ARTIFACT_KERNEL_MODULES
ARG URL_ARTIFACT_KERNEL
ARG URL_ARTIFACT_KERNEL_DEVEL
ADD ${URL_ARTIFACT_FAKE} /tmp/fake-nvidia.tar.gz
RUN mkdir -p /etc/dracut.conf.d && \
    printf "hostonly=no\n" > /etc/dracut.conf.d/99-dqd.conf && \
    dnf install -y --setopt=install_weak_deps=False \
        make \
        ${URL_ARTIFACT_KERNEL_CORE} \
        ${URL_ARTIFACT_KERNEL_MODULES_CORE} \
        ${URL_ARTIFACT_KERNEL_MODULES} \
        ${URL_ARTIFACT_KERNEL} \
        ${URL_ARTIFACT_KERNEL_DEVEL} && \
    dnf clean all
RUN tar -xzf /tmp/fake-nvidia.tar.gz -C /tmp && \
    mv /tmp/fake-nvidia-${VERSION_FAKE_NVIDIA} /usr/local/fake-nvidia && \
    rm -rf /tmp/fake-nvidia.tar.gz && \
    cd /usr/local/fake-nvidia && \
    KERNEL_RELEASE=${VERSION_KERNEL} NVIDIA_DRIVER_VERSION=${VERSION_NVIDIA_DRIVER} make install && \
    depmod ${VERSION_KERNEL}

FROM fake-nvidia AS nvidia-container-toolkit
ARG VERSION_NCT_PKG
RUN curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
    tee /etc/yum.repos.d/nvidia-container-toolkit.repo && \
    sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/nvidia-container-toolkit.repo && \
    dnf install -y \
        nvidia-container-toolkit-${VERSION_NCT_PKG} \
        nvidia-container-toolkit-base-${VERSION_NCT_PKG} \
        libnvidia-container-tools-${VERSION_NCT_PKG} \
        libnvidia-container1-${VERSION_NCT_PKG} && \
    dnf clean all

FROM nvidia-container-toolkit
ARG HOSTNAME
RUN echo "${HOSTNAME}" > /etc/hostname
