ARG HOSTNAME=runc-1-1-0-d3d7f7d
ARG VERSION_COMMIT=d3d7f7d
ARG VERSION_UBUNTU=20.04
ARG VERSION_IMAGE=0.3.0
ARG URL_ARTIFACT_RUNC=https://github.com/ssst0n3/container-debug-artifacts/releases/download/runc/runc-v1.1.0-${VERSION_COMMIT}-debug
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE}
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_ARTIFACT_RUNC
RUN apt update && apt install -y busybox-static && apt-get clean -y && rm -rf /var/lib/apt/lists/*
ADD ${URL_ARTIFACT_RUNC} /tmp/runc.amd64
RUN install -m 755 /tmp/runc.amd64 /usr/local/sbin/runc && rm /tmp/runc.amd64
RUN echo "${HOSTNAME}" > /etc/hostname
