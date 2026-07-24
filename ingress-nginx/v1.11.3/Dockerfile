# syntax=docker/dockerfile:1-labs

# ============================================================================
# Configuration variables
# ============================================================================
ARG VERSION_K8S=1.32.3
ARG VERSION_CONTAINERD=2.0.3
ARG VERSION_IMAGE=0.3.0

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/kubernetes-v${VERSION_K8S}_containerd-v${VERSION_CONTAINERD}_calico:ctr_v${VERSION_IMAGE}

FROM ${BASE_IMAGE} AS pre
COPY --chmod=755 service/init.sh /init.sh
COPY service/init.service /usr/lib/systemd/system/
RUN systemctl enable init.service

FROM pre AS ingress
ARG CACHE_BUST
RUN echo "No cache from here, value: $CACHE_BUST"
# copy image snapshots
# use cp -a instead of cp -r to preserve attributions, avoid coredns cap_net_bind_service loss
RUN --mount=type=cache,id=ingress-nginx-v1.11.3-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# install ingress-nginx
# Surface the systemd/init.sh build logs (written to /dev/kmsg) to the buildkit/CI
# log by backgrounding a /dev/kmsg reader before exec'ing systemd. systemd reopens
# its own stdout/stderr to /dev/null, so --log-target=console would surface nothing;
# the backgrounded cat holds the buildkit-captured pipe and drains kmsg into it.
# See .claude/plans/purring-whistling-stallman.md (spike) for the mechanism proof.
RUN --mount=type=cache,id=ingress-nginx-v1.11.3-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
# skip overlayfs whiteout files (char dev 0,0): covers both the work/work/#
# whiteouts and fs/ whiteouts (e.g. alpine apk cache deletions). buildkit exec
# lacks CAP_MKNOD, so tar -xf would fail recreating them.
RUN --mount=type=cache,id=ingress-nginx-v1.11.3-snapshots,target=/trick \
    find /trick -type c -delete && \
    # use tar to preserve file capabilities
    tar -C /trick -cf - . | tar -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -

FROM ingress AS final
RUN rm /usr/lib/systemd/system/init.service /init.sh
