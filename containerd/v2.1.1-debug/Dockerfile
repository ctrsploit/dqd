# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=containerd-2-1-1-debug
ARG VERSION_CONTAINERD=2.1.1
# https://github.com/containerd/containerd/blob/v2.1.1/script/setup/runc-version
ARG VERSION_RUNC=1.3.0
ARG VERSION_DLV=1.24.1
ARG VERSION_IMAGE=0.2.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_CONTAINERD=ghcr.io/ctrsploit/containerd-v${VERSION_CONTAINERD}
ARG BASE_IMAGE=${IMAGE_CONTAINERD}:ctr_v${VERSION_IMAGE}
ARG URL_ARTIFACT=https://github.com/ssst0n3/container-debug-artifacts/releases/download
ARG DIR_BIN=/root/bin

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_CONTAINERD
ARG VERSION_RUNC
ARG VERSION_DLV
ARG URL_ARTIFACT
ARG DIR_BIN
# debug binaries
RUN mkdir -p ${DIR_BIN}
ADD --chmod=755 ${URL_ARTIFACT}/containerd/containerd-v${VERSION_CONTAINERD}-debug ${DIR_BIN}/containerd.debug
ADD --chmod=755 ${URL_ARTIFACT}/containerd/containerd-stress-v${VERSION_CONTAINERD}-debug ${DIR_BIN}/containerd-stress.debug
ADD --chmod=755 ${URL_ARTIFACT}/containerd/containerd-shim-runc-v2-v${VERSION_CONTAINERD}-debug ${DIR_BIN}/containerd-shim-runc-v2.debug
ADD --chmod=755 ${URL_ARTIFACT}/containerd/ctr-v${VERSION_CONTAINERD}-debug ${DIR_BIN}/ctr.debug
ADD --chmod=755 ${URL_ARTIFACT}/runc/runc-v${VERSION_RUNC}-debug-flag ${DIR_BIN}/runc.debug
ADD --chmod=755 ${URL_ARTIFACT}/dlv/dlv-v${VERSION_DLV} /usr/local/bin/dlv
# debug scripts
COPY debug.sh /usr/local/bin/
COPY attach.sh /usr/local/bin/
# back up real binaries
RUN cp /usr/local/bin/ctr ${DIR_BIN}/ctr.real && \
    cp /usr/local/bin/containerd ${DIR_BIN}/containerd.real && \
    cp /usr/local/bin/containerd-stress ${DIR_BIN}/containerd-stress.real && \
    cp /usr/local/bin/containerd-shim-runc-v2 ${DIR_BIN}/containerd-shim-runc-v2.real && \
    cp /usr/local/sbin/runc ${DIR_BIN}/runc.real
RUN echo "${HOSTNAME}" > /etc/hostname
