# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=nvidia-container-toolkit-1-19-0
ARG VERSION_NCT=1.19.0
ARG VERSION_NCT_PKG=${VERSION_NCT}-1
ARG VERSION_FAKE_NVIDIA=0.7.2
ARG VERSION_DOCKER=28.2.0
ARG VERSION_KERNEL=6.8.0-71-generic
ARG VERSION_NVIDIA_DRIVER=575.57.08
ARG VERSION_IMAGE=0.1.0
ARG URL_ARTIFACT_FAKE=https://github.com/ssst0n3/fake-nvidia/archive/refs/tags/v${VERSION_FAKE_NVIDIA}.tar.gz
ARG URL_ARTIFACT_DRIVER=https://us.download.nvidia.com/tesla/${VERSION_NVIDIA_DRIVER}/NVIDIA-Linux-x86_64-${VERSION_NVIDIA_DRIVER}.run

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/docker-v${VERSION_DOCKER}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
# https://gitlab.com/nvidia/container-images/driver/-/blob/master/ubuntu18.04/Dockerfile#L48
FROM ${BASE_IMAGE} AS driver
ARG URL_ARTIFACT_DRIVER
ADD --chmod=755 ${URL_ARTIFACT_DRIVER} /tmp/nvidia-driver.run
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y \
        kmod \
        libc6:i386 \
        pkg-config \
        libglvnd-dev
RUN /tmp/nvidia-driver.run --silent \
    --no-kernel-module \
    --install-compat32-libs

FROM driver AS fake-nvidia
ARG VERSION_FAKE_NVIDIA
ARG VERSION_KERNEL
ARG VERSION_NVIDIA_DRIVER
ARG URL_ARTIFACT_FAKE
ADD ${URL_ARTIFACT_FAKE} /tmp/fake-nvidia.tar.gz
RUN apt update && apt install -y build-essential linux-headers-${VERSION_KERNEL} linux-image-${VERSION_KERNEL}
RUN tar -xzf /tmp/fake-nvidia.tar.gz -C /tmp && \
    mv /tmp/fake-nvidia-${VERSION_FAKE_NVIDIA} /usr/local/fake-nvidia && \
    rm -rf /tmp/fake-nvidia.tar.gz && \
    cd /usr/local/fake-nvidia && \
    KERNEL_RELEASE=${VERSION_KERNEL} NVIDIA_DRIVER_VERSION=${VERSION_NVIDIA_DRIVER} make install && \
    depmod ${VERSION_KERNEL}

FROM fake-nvidia AS nvidia-container-toolkit
ARG VERSION_NCT_PKG
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
    gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
RUN apt-get update && \
    apt-get install -y \
      nvidia-container-toolkit=${VERSION_NCT_PKG} \
      nvidia-container-toolkit-base=${VERSION_NCT_PKG} \
      libnvidia-container-tools=${VERSION_NCT_PKG} \
      libnvidia-container1=${VERSION_NCT_PKG}
RUN nvidia-ctk runtime configure --runtime=docker

FROM nvidia-container-toolkit
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname
