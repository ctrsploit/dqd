# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=podman-5-5-1-debug
ARG VERSION_PODMAN=5.5.1
ARG VERSION_IMAGE=0.1.0
ARG VERSION_DLV=1.24.2
ARG PATH_PODMAN=/usr/bin/podman
ARG DIR_BIN=/root/bin

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/podman-v${VERSION_PODMAN}:ctr_v${VERSION_IMAGE}
ARG URL_ARTIFACT=https://github.com/ssst0n3/container-debug-artifacts/releases/download

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE} AS debug
ARG VERSION_PODMAN
ARG VERSION_DLV
ARG URL_ARTIFACT
ARG PATH_PODMAN
ARG DIR_BIN
RUN mkdir -p ${DIR_BIN}
ADD --chmod=755 ${URL_ARTIFACT}/podman/podman-v${VERSION_PODMAN}-debug ${DIR_BIN}/podman.debug
ADD --chmod=755 ${URL_ARTIFACT}/dlv/dlv-v${VERSION_DLV} /usr/local/bin/dlv
COPY --chmod=755 debug.sh /usr/local/bin/
RUN cp ${PATH_PODMAN} ${DIR_BIN}/podman.real

FROM debug
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname
