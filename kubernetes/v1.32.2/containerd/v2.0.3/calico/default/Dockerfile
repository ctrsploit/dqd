# syntax=docker/dockerfile:1-labs

# ============================================================================
# Configuration variables
# ============================================================================
ARG VERSION_K8S=1.32.2
ARG VERSION_CONTAINERD=2.0.3
ARG VERSION_IMAGE=0.3.0

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/kubernetes-v${VERSION_K8S}_containerd-v${VERSION_CONTAINERD}_init:ctr_v${VERSION_IMAGE}

FROM ${BASE_IMAGE} AS pre
COPY --chmod=755 service/init.sh /init.sh
COPY service/init.service /usr/lib/systemd/system/
RUN systemctl enable init.service

FROM pre AS calico
ARG CACHE_BUST
RUN echo "No cache from here, value: $CACHE_BUST"
# copy image snapshots
# use cp -a instead of cp -r to preserve attributions, avoid coredns cap_net_bind_service loss
RUN --mount=type=cache,id=kubernetes-v1.25.0-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# install calico
RUN --mount=type=cache,id=kubernetes-v1.25.0-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    --security=insecure \
    ["/sbin/init", "--log-target=kmsg"]
# copy snapshots from cache
RUN --mount=type=cache,id=kubernetes-v1.25.0-snapshots,target=/trick \
    # all these files are safe to delete, list each file path here for more clear
    rm /trick/snapshots/65/work/work/#* && \
    # use tar to preserve file capabilities
    tar -C /trick -cf - . | tar -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -

FROM calico AS final
RUN rm /usr/lib/systemd/system/init.service /init.sh
