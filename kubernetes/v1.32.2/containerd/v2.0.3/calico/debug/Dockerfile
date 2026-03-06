# syntax=docker/dockerfile:1-labs
# ================================
# Configuration Variables
# ================================
ARG VERSION_KUBERNETES=1.32.2
ARG VERSION_CONTAINERD=2.0.3
ARG VERSION_DLV=1.26.0
ARG VERSION_IMAGE=0.2.0

# ================================
# Internal Variables
# ================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/kubernetes-v${VERSION_KUBERNETES}_containerd-v${VERSION_CONTAINERD}_calico:ctr_v${VERSION_IMAGE}
ARG URL_ARTIFACT_KUBELET_DEBUG=https://github.com/ssst0n3/container-debug-artifacts/releases/download/kubernetes/kubelet-v${VERSION_KUBERNETES}-debug
ARG URL_ARTIFACT_DLV=https://github.com/ssst0n3/container-debug-artifacts/releases/download/dlv/dlv-v${VERSION_DLV}

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG URL_ARTIFACT_KUBELET_DEBUG
ARG URL_ARTIFACT_DLV
ADD --chmod=755 ${URL_ARTIFACT_KUBELET_DEBUG} /usr/local/bin/kubelet.debug
ADD --chmod=755 ${URL_ARTIFACT_DLV} /usr/local/bin/dlv
COPY --chmod=755 debug.sh /usr/local/bin/debug.sh
# back up real kubelet binary
RUN cp /usr/bin/kubelet /usr/local/bin/kubelet.real
