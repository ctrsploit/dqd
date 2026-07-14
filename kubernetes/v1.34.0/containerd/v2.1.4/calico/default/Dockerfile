# syntax=docker/dockerfile:1-labs

# ============================================================================
# Configuration variables
# ============================================================================
ARG VERSION_K8S=1.34.0
ARG VERSION_CONTAINERD=2.1.4
ARG VERSION_IMAGE=0.1.0

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/kubernetes-v${VERSION_K8S}_containerd-v${VERSION_CONTAINERD}_init:ctr_v${VERSION_IMAGE}

FROM ${BASE_IMAGE} AS pre
COPY --chmod=755 service/init.sh /init.sh
COPY service/init.service /usr/lib/systemd/system/
RUN systemctl enable init.service

# The base image uses the fuse-overlayfs snapshotter (no overlayfs-on-overlayfs problem),
# so the Calico install runs directly under /sbin/init without the snapshot cache trick used by
# overlayfs-based bases (v1.32.x / v1.35.x).
FROM pre AS calico
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]

FROM calico AS final
RUN rm /usr/lib/systemd/system/init.service /init.sh
