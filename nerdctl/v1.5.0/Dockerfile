# ================================
# CONFIG: version pins
# ================================
ARG HOSTNAME=nerdctl-1-5-0
ARG VERSION_NERDCTL=1.5.0
# https://github.com/containerd/nerdctl/blob/v1.5.0/Dockerfile#L21
ARG VERSION_CONTAINERD=1.7.3
# https://github.com/containerd/nerdctl/blob/v1.5.0/Dockerfile#L26
ARG VERSION_BUILDKIT=0.12.0
# https://github.com/containerd/nerdctl/blob/v1.5.0/Dockerfile#L23
ARG VERSION_CNI=1.3.0
ARG VERSION_IMAGE_CONTAINERD=0.1.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_CONTAINERD=ghcr.io/ctrsploit/containerd-v${VERSION_CONTAINERD}
ARG URL_ARTIFACT_NERDCTL=https://github.com/containerd/nerdctl/releases/download/v${VERSION_NERDCTL}/nerdctl-${VERSION_NERDCTL}-linux-amd64.tar.gz
ARG URL_ARTIFACT_BUILDKIT=https://github.com/moby/buildkit/releases/download/v${VERSION_BUILDKIT}/buildkit-v${VERSION_BUILDKIT}.linux-amd64.tar.gz
ARG URL_ARTIFACT_CNI=https://github.com/containernetworking/plugins/releases/download/v${VERSION_CNI}/cni-plugins-linux-amd64-v${VERSION_CNI}.tgz
ARG URL_SOURCE_NERDCTL=https://github.com/containerd/nerdctl/archive/refs/tags/v${VERSION_NERDCTL}.tar.gz
ARG URL_SOURCE_BUILDKIT=https://github.com/moby/buildkit/archive/refs/tags/v${VERSION_BUILDKIT}.tar.gz

# ================================
# Build Stages
# ================================
FROM ${IMAGE_CONTAINERD}:ctr_v${VERSION_IMAGE_CONTAINERD} AS buildkit
ARG URL_ARTIFACT_BUILDKIT
ARG URL_SOURCE_NERDCTL
ARG URL_SOURCE_BUILDKIT
# install buildkit
# https://github.com/containerd/nerdctl/blob/v1.5.0/docs/build.md#rootful
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

FROM buildkit AS cni
ARG URL_ARTIFACT_CNI
# install CNI plugins
RUN apt update && \
    apt install -y iptables && \
    rm -rf /var/lib/apt/lists/*
ADD ${URL_ARTIFACT_CNI} /tmp/cni-plugins.tgz
RUN mkdir -p /opt/cni/bin && \
    tar Cxzvf /opt/cni/bin /tmp/cni-plugins.tgz && \
    rm /tmp/cni-plugins.tgz

FROM cni AS nerdctl
ARG URL_ARTIFACT_NERDCTL
# install nerdctl
ADD ${URL_ARTIFACT_NERDCTL} /tmp/nerdctl.tar.gz
RUN tar Cxzvvf /usr/local/bin /tmp/nerdctl.tar.gz \
    && rm /tmp/nerdctl.tar.gz

FROM nerdctl AS final
ARG HOSTNAME
RUN echo "${HOSTNAME}" > /etc/hostname
