ARG HOSTNAME=runc-debian-11-0-v1-3-0-rc-1
ARG VERSION_RUNC=1.3.0-rc.1
ARG VERSION_DEBIAN=11.0
ARG VERSION_IMAGE=0.1.0
ARG URL_ARTIFACT_RUNC=https://github.com/opencontainers/runc/releases/download/v${VERSION_RUNC}/runc.amd64
ARG BASE_IMAGE=ghcr.io/ctrsploit/debian-${VERSION_DEBIAN}:ctr_v${VERSION_IMAGE}

FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_ARTIFACT_RUNC
RUN apt update && apt install -y busybox-static && apt-get clean -y && rm -rf /var/lib/apt/lists/*
ADD --chmod=755 ${URL_ARTIFACT_RUNC} /usr/local/sbin/runc
RUN echo "${HOSTNAME}" > /etc/hostname
