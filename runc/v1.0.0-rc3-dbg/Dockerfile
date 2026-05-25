# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=runc-1-0-0-rc3-dbg
ARG VERSION_RUNC=1.0.0-rc3
ARG VERSION_DLV=1.22.1
ARG VERSION_IMAGE_RUNC=0.1.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_RUNC=ghcr.io/ctrsploit/runc-v${VERSION_RUNC}:ctr_v${VERSION_IMAGE_RUNC}
ARG URL_ARTIFACT_RUNC_DEBUG_FLAG=https://github.com/ssst0n3/container-debug-artifacts/releases/download/runc/runc-v${VERSION_RUNC}-debug-flag
ARG URL_ARTIFACT_DLV=https://github.com/ssst0n3/container-debug-artifacts/releases/download/dlv/dlv-v${VERSION_DLV}

# ================================
# Build Stages
# ================================
FROM ${IMAGE_RUNC}
ARG HOSTNAME
ARG URL_ARTIFACT_RUNC_DEBUG_FLAG
ARG URL_ARTIFACT_DLV
WORKDIR /root
RUN mkdir -p rootfs/bin/ && \
    cp /bin/busybox rootfs/bin/ && \
    ln -s /bin/busybox rootfs/bin/sh && \
    runc spec
ADD --chmod=755 ${URL_ARTIFACT_RUNC_DEBUG_FLAG} /root/runc-debug-flag
ADD --chmod=755 ${URL_ARTIFACT_DLV} /usr/local/bin/dlv
COPY runc.debug /root/runc.debug
COPY attach.sh /usr/local/bin/
RUN mv /usr/local/sbin/runc /root/runc.real && \
    ln -s /root/runc.debug /usr/local/sbin/runc
RUN echo "${HOSTNAME}" > /etc/hostname
