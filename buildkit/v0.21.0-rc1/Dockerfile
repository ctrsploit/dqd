# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=buildkit-0-21-0-rc1
ARG VERSION_BUILDKIT=0.21.0-rc1
# https://github.com/moby/buildkit/blob/v0.21.0-rc1/Dockerfile#L3
ARG VERSION_RUNC=1.2.6
ARG IMAGE_RUNC=ghcr.io/ctrsploit/runc-v${VERSION_RUNC}
ARG VERSION_IMAGE=0.1.0

# ================================
# Internal Variables
# ================================
ARG URL_ARTIFACT_BUILDKIT=https://github.com/moby/buildkit/releases/download/v${VERSION_BUILDKIT}/buildkit-v${VERSION_BUILDKIT}.linux-amd64.tar.gz
ARG URL_GITRAW_BUILDKIT=https://raw.githubusercontent.com/moby/buildkit/refs/tags/v${VERSION_BUILDKIT}
ARG BASE_IMAGE=${IMAGE_RUNC}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG URL_ARTIFACT_BUILDKIT
ARG URL_GITRAW_BUILDKIT
# install buildkit
ADD ${URL_ARTIFACT_BUILDKIT} /tmp/buildkit.tar.gz
RUN tar Cxzvvf /usr/local/ /tmp/buildkit.tar.gz \
    && rm /tmp/buildkit.tar.gz
# config systemd
ADD ${URL_GITRAW_BUILDKIT}/examples/systemd/system/buildkit.service /usr/local/lib/systemd/system/buildkit.service
ADD ${URL_GITRAW_BUILDKIT}/examples/systemd/system/buildkit.socket /usr/local/lib/systemd/system/buildkit.socket
RUN systemctl enable buildkit.service
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname
