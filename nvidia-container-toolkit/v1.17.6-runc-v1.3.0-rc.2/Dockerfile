ARG HOSTNAME=nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2
ARG VERSION_RUNC=1.3.0-rc.2
ARG VERSION_IMAGE=0.9.0
ARG URL_ARTIFACT_RUNC=https://github.com/opencontainers/runc/releases/download/v${VERSION_RUNC}/runc.amd64
ARG BASE_IMAGE=ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6:ctr_v${VERSION_IMAGE}

FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_ARTIFACT_RUNC
ADD --chmod=755 ${URL_ARTIFACT_RUNC} /usr/bin/runc
RUN echo "${HOSTNAME}" > /etc/hostname
