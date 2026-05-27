# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=buildkit-0-3-0
ARG VERSION_BUILDKIT=0.3.0
# https://github.com/moby/buildkit/blob/v0.3.0/hack/dockerfiles/test.buildkit.Dockerfile#L3
ARG VERSION_RUNC=1.0.0-rc6
ARG IMAGE_RUNC=ghcr.io/ctrsploit/runc-v${VERSION_RUNC}
ARG VERSION_IMAGE=0.1.0

# ================================
# Internal Variables
# ================================
ARG URL_ARTIFACT_BUILDKIT=https://github.com/moby/buildkit/releases/download/v${VERSION_BUILDKIT}/buildkit-v${VERSION_BUILDKIT}.linux-amd64.tar.gz
ARG BASE_IMAGE=${IMAGE_RUNC}:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG URL_ARTIFACT_BUILDKIT
# install buildkit
ADD ${URL_ARTIFACT_BUILDKIT} /tmp/buildkit.tar.gz
RUN tar Cxzvvf /usr/local/ /tmp/buildkit.tar.gz \
    && rm /tmp/buildkit.tar.gz
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname
