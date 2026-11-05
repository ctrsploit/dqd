# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=podman-6-1-4-runc-v1-5-2
ARG VERSION_RUNC=1.5.2
ARG VERSION_IMAGE=0.1.0

# ================================
# Internal Variables
# ================================
# Replace podman's default OCI runtime (crun, shipped by the Fedora 45
# podman-6.1 stack) with upstream runc 1.5.2 and point the engine at it.
# A plain runtime variant: no seccomp pin, no containers/common freeze.
ARG URL_ARTIFACT_RUNC=https://github.com/opencontainers/runc/releases/download/v${VERSION_RUNC}/runc.amd64
ARG BASE_IMAGE=ghcr.io/ctrsploit/podman-v6.1.4:ctr_v${VERSION_IMAGE}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_ARTIFACT_RUNC
ADD --chmod=755 ${URL_ARTIFACT_RUNC} /usr/bin/runc
RUN printf '[engine]\nruntime = "runc"\n' > /etc/containers/containers.conf && \
    echo "${HOSTNAME}" > /etc/hostname
