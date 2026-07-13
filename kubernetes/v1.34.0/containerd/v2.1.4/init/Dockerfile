# syntax=docker/dockerfile:1-labs

# ============================================================================
# Configuration variables
# ============================================================================
ARG VERSION_K8S=1.34.0
ARG VERSION_CONTAINERD=2.1.4
# k8s version: https://github.com/kubernetes-sigs/kind/blob/v0.28.0/pkg/apis/config/defaults/image.go#L21
ARG VERSION_KIND=0.28.0
ARG VERSION_IMAGE=0.1.0

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/kubernetes-v${VERSION_K8S}_containerd-v${VERSION_CONTAINERD}_base:ctr_v${VERSION_IMAGE}
ARG URL_ARTIFACT_KIND=https://raw.githubusercontent.com/kubernetes-sigs/kind/refs/tags/v${VERSION_KIND}

# ============================================================================
# Build stages
# ============================================================================
FROM ${BASE_IMAGE} AS kube_init
ARG URL_ARTIFACT_KIND
# kubeadm init
ADD ${URL_ARTIFACT_KIND}/images/base/files/etc/systemd/system/kubelet.service.d/11-kind.conf /etc/systemd/system/kubelet.service.d/11-kind.conf
ADD --chmod=755 ${URL_ARTIFACT_KIND}/images/base/files/kind/bin/create-kubelet-cgroup-v2.sh /kind/bin/create-kubelet-cgroup-v2.sh
COPY service/kubeadm.conf /kind/
COPY service/init.sh /
COPY service/init.service /usr/lib/systemd/system/
COPY service/setup-hosts.service /usr/lib/systemd/system/
RUN chmod 755 /init.sh && \
    systemctl enable kubelet.service && \
    systemctl enable init.service
ENV KUBECONFIG=/etc/kubernetes/admin.conf
# create-kubelet-cgroup-v2.sh exits 1 in non-docker environments; relax it for the build sandbox
RUN sed -i '/exit 1/d' /kind/bin/create-kubelet-cgroup-v2.sh
# The base image uses the fuse-overlayfs snapshotter (no overlayfs-on-overlayfs problem),
# so kubeadm init runs directly under /sbin/init without the snapshot cache trick used by
# overlayfs-based bases (v1.32.x / v1.35.x).
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]

FROM kube_init AS final
RUN mkdir -p /root/.kube && \
    cp /etc/kubernetes/admin.conf /root/.kube/config && \
    rm /usr/lib/systemd/system/init.service /init.sh && \
    systemctl enable setup-hosts.service
