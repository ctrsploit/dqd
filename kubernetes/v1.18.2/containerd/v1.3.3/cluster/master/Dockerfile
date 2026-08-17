# syntax=docker/dockerfile:1-labs
ARG VERSION_K8S=1.18.2
ARG VERSION_CONTAINERD=1.3.3
# the calico base image is at v0.1.4 (its own bump history); not v0.1.0
ARG VERSION_IMAGE=0.1.4
ARG BASE_IMAGE=ghcr.io/ctrsploit/kubernetes-v${VERSION_K8S}_containerd-v${VERSION_CONTAINERD}_calico

FROM ${BASE_IMAGE}:ctr_v${VERSION_IMAGE} AS pre
COPY --chmod=755 service/init.sh /init.sh
COPY service/init.service /usr/lib/systemd/system/
COPY --chmod=755 service/hosts.sh /hosts.sh
COPY service/hosts.service /usr/lib/systemd/system/
RUN systemctl enable init.service && \
    systemctl enable hosts.service && \
    systemctl disable kubelet.service

FROM pre AS wait-join
# there seems a bug in systemd when executing `systemctl exit 0`:
#   ExitCode can only be set for user service managers or in containers.
# a trick to allow `systemctl exit 0` is setup the env container
# https://github.com/systemd/systemd/blob/v245.4/src/basic/virt.c#L503
ENV container=docker
# copy image snapshots
RUN --mount=type=cache,id=kubernetes-v1.18.2-snapshots,target=/trick \
    cp -r /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
ARG CACHE_BUST
RUN echo "No cache from here, value: $CACHE_BUST"
# wait join
RUN --mount=type=cache,id=kubernetes-v1.18.2-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    --security=insecure \
    ["/sbin/init", "--log-target=kmsg"]
# copy snapshots from cache
RUN --mount=type=cache,id=kubernetes-v1.18.2-snapshots,target=/trick \
    cp -rf /trick/* /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ || true

FROM wait-join AS final
RUN rm /usr/lib/systemd/system/init.service /init.sh
RUN apt update && \
    apt install -y cloud-init && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
