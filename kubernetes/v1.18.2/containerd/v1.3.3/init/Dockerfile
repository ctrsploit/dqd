# syntax=docker/dockerfile:1-labs

ARG VERSION_K8S=1.18.2
ARG VERSION_CONTAINERD=1.3.3
ARG VERSION_IMAGE=0.1.0
ARG BASE_IMAGE=ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_base:ctr_v${VERSION_IMAGE}

FROM ${BASE_IMAGE} AS pre
COPY service/kubeadm.conf /kind/
COPY --chmod=755 service/init.sh /
COPY service/init.service /usr/lib/systemd/system/
COPY --chmod=755 service/hosts.sh /
COPY service/hosts.service /usr/lib/systemd/system/
COPY service/cgroup-kill.service /usr/lib/systemd/system/cgroup-kill.service
RUN systemctl enable kubelet.service && systemctl enable init.service && systemctl enable cgroup-kill.service

FROM pre AS kube_init
ENV KUBECONFIG=/etc/kubernetes/admin.conf
ENV container=docker
ARG CACHE_BUST
RUN echo "No cache from here, value: $CACHE_BUST"
RUN --mount=type=cache,id=kubernetes-v1.18.2-containerd-v1.3.3-snapshots,target=/trick cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
RUN --mount=type=cache,id=kubernetes-v1.18.2-containerd-v1.3.3-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs --mount=type=bind,src=/modules,target=/lib/modules --security=insecure ["/sbin/init", "--log-target=kmsg"]
RUN --mount=type=cache,id=kubernetes-v1.18.2-containerd-v1.3.3-snapshots,target=/trick --security=insecure cp -rf /trick/* /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ || true

FROM kube_init AS final
RUN mkdir -p /root/.kube && cp /etc/kubernetes/admin.conf /root/.kube/config && rm /usr/lib/systemd/system/init.service /init.sh && systemctl enable hosts.service
