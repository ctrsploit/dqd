# syntax=docker/dockerfile:1-labs
# ================================
# Configuration Variables
# ================================
ARG VERSION_K8S=1.32.4
# https://github.com/kubernetes/website/blob/release-1.34/content/en/docs/setup/production-environment/tools/kubeadm/install-kubeadm.md?plain=1#L368
ARG VERSION_K8S_RELEASE=0.16.2
# kubespray introduced containerd v2.0.4
# https://github.com/kubernetes-sigs/kubespray/commit/26bd2d8e9c040fe3549b836e68b6e4b25c795129#diff-085fa9b23e68296b1a0ae938e59513dc08f31240cc11ea681d5b9074bd5bad6dR1023
# the latest kubelet and kubectl in kubespray are v1.32.4
# https://github.com/kubernetes-sigs/kubespray/blob/26bd2d8e9c040fe3549b836e68b6e4b25c795129/roles/kubespray-defaults/defaults/main/checksums.yml#L130
ARG VERSION_CONTAINERD=2.0.4
# https://github.com/kubernetes-sigs/kubespray/blob/26bd2d8e9c040fe3549b836e68b6e4b25c795129/roles/kubespray-defaults/defaults/main/checksums.yml#L455
ARG VERSION_CNI_PLUGINS=1.4.1
# https://github.com/kubernetes-sigs/kubespray/blob/26bd2d8e9c040fe3549b836e68b6e4b25c795129/roles/kubespray-defaults/defaults/main/checksums.yml#L10
ARG VERSION_CRICTL=1.32.0
# https://github.com/kubernetes-sigs/kubespray/blob/26bd2d8e9c040fe3549b836e68b6e4b25c795129/roles/kubespray-defaults/defaults/main/checksums.yml#L640
ARG VERSION_HELM=3.16.4
# https://github.com/containerd/nerdctl/blob/v2.0.4/Dockerfile#L20
ARG VERSION_NERDCTL=2.0.4
# https://github.com/containerd/nerdctl/blob/v2.0.4/Dockerfile#L25
ARG VERSION_BUILDKIT=0.20.1
ARG VERSION_IMAGE_CONTAINERD=0.3.0

# ================================
# Internal Variables
# ================================
# the kubelet.service relies on '/usr/bin/kubelet'
ARG DIR_BIN=/usr/bin
ARG BASE_IMAGE=ghcr.io/ctrsploit/containerd-v${VERSION_CONTAINERD}:ctr_v${VERSION_IMAGE_CONTAINERD}
ARG URL_ARTIFACT_CNI=https://github.com/containernetworking/plugins/releases/download/v${VERSION_CNI_PLUGINS}/cni-plugins-linux-amd64-v${VERSION_CNI_PLUGINS}.tgz
ARG URL_ARTIFACT_HELM=https://get.helm.sh/helm-v${VERSION_HELM}-linux-amd64.tar.gz
ARG URL_ARTIFACT_K8S_BIN=https://dl.k8s.io/release/v${VERSION_K8S}/bin/linux/amd64
ARG URL_ARTIFACT_CRICTL=https://github.com/kubernetes-sigs/cri-tools/releases/download/v${VERSION_CRICTL}/crictl-v${VERSION_CRICTL}-linux-amd64.tar.gz
ARG URL_ARTIFACT_NERDCTL=https://github.com/containerd/nerdctl/releases/download/v${VERSION_NERDCTL}/nerdctl-${VERSION_NERDCTL}-linux-amd64.tar.gz
ARG URL_ARTIFACT_BUILDKIT=https://github.com/moby/buildkit/releases/download/v${VERSION_BUILDKIT}/buildkit-v${VERSION_BUILDKIT}.linux-amd64.tar.gz
ARG URL_SOURCE_K8S_RELEASE=https://github.com/kubernetes/release/archive/refs/tags/v${VERSION_K8S_RELEASE}.tar.gz
ARG URL_SOURCE_NERDCTL=https://github.com/containerd/nerdctl/archive/refs/tags/v${VERSION_NERDCTL}.tar.gz
ARG URL_SOURCE_BUILDKIT=https://github.com/moby/buildkit/archive/refs/tags/v${VERSION_BUILDKIT}.tar.gz

FROM ${BASE_IMAGE} AS prerequisite
ARG URL_ARTIFACT_CNI
RUN apt update && \
    apt install -y \
        curl \
        iproute2 \
        iptables && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
# ipv4 forwarding
RUN echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/k8s.conf
    # not work in dockerfile
    # sysctl --system
# cgroup driver: systemd is the default

FROM prerequisite AS helm
ARG URL_ARTIFACT_HELM
ADD ${URL_ARTIFACT_HELM} /tmp/helm.tar.gz
RUN tar -C /tmp -xzvf /tmp/helm.tar.gz && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz

FROM helm AS cni
# install CNI plugins
ADD ${URL_ARTIFACT_CNI} /tmp/cni-plugins.tgz
RUN mkdir -p /opt/cni/bin && \
    tar Cxzvf /opt/cni/bin /tmp/cni-plugins.tgz && \
    rm /tmp/cni-plugins.tgz

FROM cni AS crictl
ARG URL_ARTIFACT_CRICTL
ARG DIR_BIN
RUN curl -L ${URL_ARTIFACT_CRICTL} | tar -C ${DIR_BIN} -xz && \
    echo 'runtime-endpoint: unix:///var/run/containerd/containerd.sock' > /etc/crictl.yaml

FROM crictl AS buildkit
ARG URL_ARTIFACT_BUILDKIT
ARG URL_SOURCE_NERDCTL
ARG URL_SOURCE_BUILDKIT
# install buildkit
ADD ${URL_ARTIFACT_BUILDKIT} /tmp/buildkit.tar.gz
RUN tar Cxzvvf /usr/local/ /tmp/buildkit.tar.gz \
    && rm /tmp/buildkit.tar.gz
# enable containerd worker
ADD ${URL_SOURCE_NERDCTL} /tmp/nerdctl-src.tar.gz
RUN mkdir -p /tmp/nerdctl-src /etc/buildkit && \
    tar -xzf /tmp/nerdctl-src.tar.gz -C /tmp/nerdctl-src --strip-components=1 && \
    cp /tmp/nerdctl-src/Dockerfile.d/etc_buildkit_buildkitd.toml /etc/buildkit/buildkitd.toml && \
    rm -rf /tmp/nerdctl-src /tmp/nerdctl-src.tar.gz
# config systemd
ADD ${URL_SOURCE_BUILDKIT} /tmp/buildkit-src.tar.gz
RUN mkdir -p /tmp/buildkit-src && \
    tar -xzf /tmp/buildkit-src.tar.gz -C /tmp/buildkit-src --strip-components=1 && \
    cp /tmp/buildkit-src/examples/systemd/system/buildkit.service /usr/local/lib/systemd/system/buildkit.service && \
    cp /tmp/buildkit-src/examples/systemd/system/buildkit.socket /usr/local/lib/systemd/system/buildkit.socket && \
    rm -rf /tmp/buildkit-src /tmp/buildkit-src.tar.gz
RUN systemctl enable buildkit.service

FROM buildkit AS nerdctl
ARG URL_ARTIFACT_NERDCTL
# install nerdctl
ADD ${URL_ARTIFACT_NERDCTL} /tmp/nerdctl.tar.gz
RUN tar Cxzvvf /usr/local/bin /tmp/nerdctl.tar.gz \
    && rm /tmp/nerdctl.tar.gz

FROM nerdctl AS kube
ARG URL_ARTIFACT_K8S_BIN
ARG URL_SOURCE_K8S_RELEASE
ARG DIR_BIN
ADD ${URL_SOURCE_K8S_RELEASE} /tmp/k8s-release-src.tar.gz
# install kubeadm, kubelet, kubectl
# https://github.com/kubernetes/website/blob/release-1.25/content/en/docs/setup/production-environment/tools/kubeadm/install-kubeadm.md#installing-kubeadm-kubelet-and-kubectl
RUN set -ex && \
    cd ${DIR_BIN} && \
    curl -L --remote-name-all ${URL_ARTIFACT_K8S_BIN}/{kubeadm,kubelet,kubectl} && \
    chmod +x kubeadm kubelet kubectl && \
    mkdir -p /tmp/k8s-release-src && \
    tar -xzf /tmp/k8s-release-src.tar.gz -C /tmp/k8s-release-src --strip-components=1 && \
    cp /tmp/k8s-release-src/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service \
        /etc/systemd/system/kubelet.service && \
    mkdir -p /etc/systemd/system/kubelet.service.d && \
    cp /tmp/k8s-release-src/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf \
        /etc/systemd/system/kubelet.service.d/10-kubeadm.conf && \
    rm -rf /tmp/k8s-release-src /tmp/k8s-release-src.tar.gz

FROM kube AS preflight
ARG VERSION_K8S
COPY --chmod=755 pull.sh /tmp/
RUN --security=insecure /tmp/pull.sh
