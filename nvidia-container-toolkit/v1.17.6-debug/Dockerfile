# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=nvidia-container-toolkit-1-17-6-debug
ARG VERSION_NCT=1.17.6
ARG VERSION_RUNC=1.2.5
ARG VERSION_DLV=1.24.2
ARG VERSION_IMAGE=0.9.0
ARG PATH_RUNC=/usr/bin/runc
ARG PATH_NCT=/usr/bin/nvidia-container-runtime
ARG DIR_BIN=/root/bin

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/nvidia-container-toolkit-v${VERSION_NCT}:ctr_v${VERSION_IMAGE}
ARG URL_ARTIFACT=https://github.com/ssst0n3/container-debug-artifacts/releases/download

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE} AS debug
ARG VERSION_NCT
ARG VERSION_RUNC
ARG VERSION_DLV
ARG URL_ARTIFACT
ARG PATH_NCT
ARG PATH_RUNC
ARG DIR_BIN
RUN mkdir -p ${DIR_BIN}
# debug binaries
ADD --chmod=755 ${URL_ARTIFACT}/nvidia-container-toolkit/nvidia-container-runtime-v${VERSION_NCT}-debug ${DIR_BIN}/nvidia-container-runtime.debug
ADD --chmod=755 ${URL_ARTIFACT}/runc/runc-v${VERSION_RUNC}-debug-flag ${DIR_BIN}/runc.debug
ADD --chmod=755 ${URL_ARTIFACT}/dlv/dlv-v${VERSION_DLV} /usr/local/bin/dlv
# debug scripts
COPY --chmod=755 debug.sh /usr/local/bin/
COPY --chmod=755 attach.sh /usr/local/bin/
# back up real binaries
RUN cp ${PATH_NCT} ${DIR_BIN}/nvidia-container-runtime.real && \
    cp ${PATH_RUNC} ${DIR_BIN}/runc.real

FROM debug
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname
