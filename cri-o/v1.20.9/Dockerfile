# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=cri-o-1-20-9
ARG VERSION_CRIO=1.20.9
ARG VERSION_UBUNTU=20.04
ARG VERSION_IMAGE_UBUNTU=0.3.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_UBUNTU=ghcr.io/ctrsploit/ubuntu-${VERSION_UBUNTU}:ctr_v${VERSION_IMAGE_UBUNTU}
# cri-o official static bundle: crio, conmon, crictl, pinns, runc, crun,
# CNI plugins, crio.conf, crictl.yaml, crio.service, policy.json -- self-contained.
ARG URL_CRIO_BUNDLE=https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v${VERSION_CRIO}.tar.gz

# ================================
# Build Stages
# ================================
FROM ${IMAGE_UBUNTU}
ARG HOSTNAME
ARG URL_CRIO_BUNDLE
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      iptables ca-certificates curl jq && \
    rm -rf /var/lib/apt/lists/*
ADD ${URL_CRIO_BUNDLE} /tmp/crio-bundle.tgz
RUN tar xzf /tmp/crio-bundle.tgz -C /tmp && \
    install -m 755 /tmp/cri-o/bin/crio /tmp/cri-o/bin/crio-status /tmp/cri-o/bin/pinns \
      /tmp/cri-o/bin/conmon /tmp/cri-o/bin/crictl /tmp/cri-o/bin/runc /tmp/cri-o/bin/crun \
      /usr/local/bin/ && \
    install -m 755 -d /opt/cni/bin && \
    install -m 755 /tmp/cri-o/cni-plugins/* /opt/cni/bin/ && \
    install -m 755 -d /etc/crio /etc/cni/net.d /etc/containers && \
    install -m 644 /tmp/cri-o/etc/crio.conf /etc/crio/crio.conf && \
    install -m 644 /tmp/cri-o/etc/crio-umount.conf /etc/crio/ && \
    install -m 644 /tmp/cri-o/etc/crictl.yaml /etc/crictl.yaml && \
    install -m 644 /tmp/cri-o/contrib/10-crio-bridge.conf /etc/cni/net.d/ && \
    install -m 644 /tmp/cri-o/contrib/policy.json /etc/containers/ && \
    install -m 644 /tmp/cri-o/contrib/crio.service /etc/systemd/system/ && \
    sed -i 's|k8s.gcr.io/pause|registry.k8s.io/pause|' /etc/crio/crio.conf && \
    rm -rf /tmp/cri-o /tmp/crio-bundle.tgz
RUN systemctl enable crio.service && \
    printf '%s\n' \
      '{' \
      '  "metadata": { "name": "crio-demo-sandbox", "namespace": "default", "attempt": 1 },' \
      '  "hostname": "crio-demo",' \
      '  "log_directory": "/tmp",' \
      '  "linux": {}' \
      '}' > /root/pod.json && \
    printf '%s\n' \
      '{' \
      '  "metadata": { "name": "crio-demo" },' \
      '  "image": { "image": "docker.io/library/busybox:latest" },' \
      '  "command": [ "sleep", "300" ],' \
      '  "log_path": "crio-demo.log",' \
      '  "linux": {}' \
      '}' > /root/container.json && \
    echo "${HOSTNAME}" > /etc/hostname
