# ================================
# Configuration Variables
# ================================
ARG VERSION_RUNC=1.2.5
ARG VERSION_DLV=1.24.2
ARG VERSION_IMAGE=0.2.0

# ================================
# Internal Variables
# ================================
ARG URL_ARTIFACT_RUNC=https://github.com/ssst0n3/container-debug-artifacts/releases/download/runc/runc-v${VERSION_RUNC}-debug-flag
ARG URL_ARTIFACT_DLV=https://github.com/ssst0n3/container-debug-artifacts/releases/download/dlv/dlv-v${VERSION_DLV}
ARG BASE_IMAGE=ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG URL_ARTIFACT_RUNC
ARG URL_ARTIFACT_DLV
ADD --chmod=755 ${URL_ARTIFACT_RUNC} /root/runc-debug-flag
ADD --chmod=755 ${URL_ARTIFACT_DLV} /usr/local/bin/dlv
COPY --chmod=755 runc.debug /root/runc.debug
COPY --chmod=755 attach.sh /usr/local/bin/
RUN mv /usr/bin/runc /root/runc.real && \
    ln -s /root/runc.real /usr/bin/runc
