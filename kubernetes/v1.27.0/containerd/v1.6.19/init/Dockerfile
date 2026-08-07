# syntax=docker/dockerfile:1-labs

# ------------------------------------------------------------------------------
# Config
# ------------------------------------------------------------------------------
ARG VERSION_K8S=1.27.0
ARG VERSION_CONTAINERD=1.6.19
ARG VERSION_IMAGE=0.1.0

# ------------------------------------------------------------------------------
# Derived values
# ------------------------------------------------------------------------------
ARG BASE_IMAGE=ghcr.io/ctrsploit/kubernetes-v${VERSION_K8S}_containerd-v${VERSION_CONTAINERD}_base:ctr_v${VERSION_IMAGE}

# ------------------------------------------------------------------------------
# Build stages
# ------------------------------------------------------------------------------
FROM ${BASE_IMAGE} AS pre
COPY service/kubeadm.conf /kind/
COPY --chmod=755 service/init.sh /
COPY service/init.service /usr/lib/systemd/system/
COPY --chmod=755 service/hosts.sh /
COPY service/hosts.service /usr/lib/systemd/system/
# fix systemd-245 systemd-shutdown hangs on containerd-shim
# https://github.com/k3s-io/k3s/issues/6218
COPY service/cgroup-kill.service /usr/lib/systemd/system/cgroup-kill.service
RUN systemctl enable kubelet.service && \
    systemctl enable init.service && \
    systemctl enable cgroup-kill.service
# fix 'apparmor-parser missing'
RUN apt update && \
    apt install -y apparmor-utils && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
# k8s control-plane containers always restart when kubelet and containerd use different cgroup drivers.
RUN mkdir -p /etc/containerd && \
    containerd config default > /etc/containerd/config.toml && \
    sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

FROM pre AS kube_init
# kubeadm init
ENV KUBECONFIG=/etc/kubernetes/admin.conf
# systemctl exit only accepts ExitCode in detected container environments on systemd 245.
ENV container=docker
ARG CACHE_BUST
RUN echo "No cache from here, value: $CACHE_BUST"
# copy image snapshots
RUN --mount=type=cache,id=kubernetes-v1.27.0_containerd-v1.6.19-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# kubeadm init under ext4 fs
RUN --mount=type=cache,id=kubernetes-v1.27.0_containerd-v1.6.19-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    --mount=type=bind,src=/modules,target=/lib/modules \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
# restore snapshots from cache, skipping overlayfs whiteout files (c 0,0)
RUN --mount=type=cache,id=kubernetes-v1.27.0_containerd-v1.6.19-snapshots,target=/trick \
    --security=insecure \
    find /trick/snapshots -type c -delete && \
    tar -C /trick -cf - . | tar -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -

FROM kube_init AS final
RUN mkdir -p /root/.kube && \
    cp /etc/kubernetes/admin.conf /root/.kube/config && \
    rm /usr/lib/systemd/system/init.service /init.sh && \
    systemctl enable hosts.service
