# ============================================================================
# Configuration variables
# ============================================================================
ARG HOSTNAME=harbor-v2-15-2
ARG VERSION_HARBOR=2.15.2
ARG VERSION_IMAGE=0.1.0

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/docker-v28.2.2:ctr_v${VERSION_IMAGE}

# ============================================================================
# Build stages
# ============================================================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_HARBOR

# install harbor at first boot via systemd oneshot (docker compose-managed
# services are not captured by the build-time snapshot trick, so we install
# at boot instead — like ctf/cve-2019-14271's setup-challenge pattern)
COPY --chmod=755 service/init.sh /usr/local/bin/harbor-init.sh
COPY service/init.service /usr/lib/systemd/system/harbor-init.service
RUN systemctl enable harbor-init.service

RUN echo "${HOSTNAME}" > /etc/hostname
