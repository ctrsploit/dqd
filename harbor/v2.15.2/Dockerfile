# syntax=docker/dockerfile:1-labs

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
FROM ${BASE_IMAGE} AS pre
COPY --chmod=755 service/init.sh /init.sh
COPY service/init.service /usr/lib/systemd/system/
RUN systemctl enable init.service

FROM pre AS harbor
ARG CACHE_BUST
RUN echo "No cache from here, value: $CACHE_BUST"
# copy docker state snapshots (base image has no /var/lib/docker yet, so this
# is a no-op on first build; on rebuild it seeds the cache from a prior build)
RUN --mount=type=cache,id=harbor-v2.15.2-snapshots,target=/trick \
    if [ -d /var/lib/docker ]; then cp -a /var/lib/docker/. /trick/; fi
# install harbor: systemd starts dockerd, init.sh runs the official installer,
# `docker compose up -d` starts 9 containers with restart: always.
# Surface the systemd/init.sh build logs (written to /dev/kmsg) to the buildkit/CI
# log by backgrounding a /dev/kmsg reader before exec'ing systemd.
RUN --mount=type=cache,id=harbor-v2.15.2-snapshots,target=/var/lib/docker \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
# skip overlayfs whiteout files (char dev 0,0): buildkit exec lacks CAP_MKNOD,
# so tar -xf would fail recreating them.
RUN --mount=type=cache,id=harbor-v2.15.2-snapshots,target=/trick \
    find /trick -type c -delete && \
    # use tar to preserve file capabilities
    tar -C /trick -cf - . | tar -C /var/lib/docker/ -xf -

FROM harbor AS final
RUN rm /usr/lib/systemd/system/init.service /init.sh
