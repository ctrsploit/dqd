# ============================================================================
# Configuration variables
# ============================================================================
ARG HOSTNAME=firecracker-1-16-1
ARG VERSION_FC=1.16.1
ARG VERSION_IMAGE=0.4.0

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-24.04:ctr_v${VERSION_IMAGE}
ARG URL_FC=https://github.com/firecracker-microvm/firecracker/releases/download/v${VERSION_FC}/firecracker-v${VERSION_FC}-x86_64.tgz
ARG URL_FC_SHA=https://github.com/firecracker-microvm/firecracker/releases/download/v${VERSION_FC}/firecracker-v${VERSION_FC}-x86_64.tgz.sha256.txt
# firectl is the firecracker-microvm CLI wrapper; the project was archived
# upstream in Nov 2026 and v0.2.0 is the final release.
ARG VERSION_FIRECTL=0.2.0
ARG URL_FIRECTL=https://github.com/firecracker-microvm/firectl/releases/download/v${VERSION_FIRECTL}/firectl-v${VERSION_FIRECTL}
ARG URL_FIRECTL_SHA=https://github.com/firecracker-microvm/firectl/releases/download/v${VERSION_FIRECTL}/firectl-v${VERSION_FIRECTL}.sha256
# Guest assets are the firecracker CI artifacts (spec.ccfc.min bucket stops at
# v1.10); they stay compatible with newer firecracker releases (virtio-mmio
# microvm ABI is unchanged).
ARG URL_CI=https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.10/x86_64
ARG ASSETS_DIR=/opt/firecracker

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG VERSION_FC
ARG URL_FC
ARG URL_FC_SHA
ARG VERSION_FIRECTL
ARG URL_FIRECTL
ARG URL_FIRECTL_SHA
ARG URL_CI
ARG ASSETS_DIR

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install firecracker, jailer and the release helpers, verified against the
# release's sha256 list.
RUN set -eux; \
    curl -fsSL "${URL_FC}" -o /tmp/firecracker.tgz; \
    curl -fsSL "${URL_FC_SHA}" -o /tmp/firecracker.tgz.sha256.txt; \
    cd /tmp; \
    echo "$(awk '{print $1}' firecracker.tgz.sha256.txt)  firecracker.tgz" | sha256sum -c -; \
    mkdir -p /tmp/fc-release; \
    tar -xzf firecracker.tgz -C /tmp/fc-release; \
    for f in firecracker-v${VERSION_FC}-x86_64 jailer-v${VERSION_FC}-x86_64 seccompiler-bin-v${VERSION_FC}-x86_64 rebase-snap-v${VERSION_FC}-x86_64; do \
      install -m 755 "/tmp/fc-release/release-v${VERSION_FC}-x86_64/${f}" "/usr/local/bin/${f}"; \
    done; \
    ln -s "/usr/local/bin/firecracker-v${VERSION_FC}-x86_64" /usr/local/bin/firecracker; \
    ln -s "/usr/local/bin/jailer-v${VERSION_FC}-x86_64" /usr/local/bin/jailer; \
    ln -s "/usr/local/bin/seccompiler-bin-v${VERSION_FC}-x86_64" /usr/local/bin/seccompiler-bin; \
    ln -s "/usr/local/bin/rebase-snap-v${VERSION_FC}-x86_64" /usr/local/bin/rebase-snap; \
    rm -rf /tmp/firecracker.tgz /tmp/firecracker.tgz.sha256.txt /tmp/fc-release; \
    firecracker --version

# Install firectl, verified against the release's sha256.
RUN set -eux; \
    curl -fsSL "${URL_FIRECTL}" -o "/tmp/firectl-v${VERSION_FIRECTL}"; \
    curl -fsSL "${URL_FIRECTL_SHA}" -o "/tmp/firectl-v${VERSION_FIRECTL}.sha256"; \
    cd /tmp; \
    echo "$(awk '{print $1}' "/tmp/firectl-v${VERSION_FIRECTL}.sha256")  firectl-v${VERSION_FIRECTL}" | sha256sum -c -; \
    install -m 755 "/tmp/firectl-v${VERSION_FIRECTL}" /usr/local/bin/firectl; \
    rm -rf "/tmp/firectl-v${VERSION_FIRECTL}" "/tmp/firectl-v${VERSION_FIRECTL}.sha256"; \
    firectl --version

# Guest kernel and rootfs for booting a microVM. The rootfs ships root SSH
# access via its paired id_rsa key.
RUN set -eux; \
    mkdir -p "${ASSETS_DIR}"; \
    curl -fsSL "${URL_CI}/vmlinux-6.1.102" -o "${ASSETS_DIR}/vmlinux-6.1.102"; \
    curl -fsSL "${URL_CI}/ubuntu-22.04.ext4" -o "${ASSETS_DIR}/ubuntu-22.04.ext4"; \
    curl -fsSL "${URL_CI}/ubuntu-22.04.id_rsa" -o "${ASSETS_DIR}/ubuntu-22.04.id_rsa"; \
    chmod 600 "${ASSETS_DIR}/ubuntu-22.04.id_rsa"; \
    chmod 444 "${ASSETS_DIR}/vmlinux-6.1.102" "${ASSETS_DIR}/ubuntu-22.04.ext4"

# The lab VM is started with `-cpu host` (see docker-compose.yml), so the
# guest exposes vmx/svm and kvm_intel/kvm_amd can load for nested virtual VMs.
RUN cat > /usr/local/bin/firecracker-kvm-module.sh <<'EOF'
#!/bin/sh
set -u
if grep -q vmx /proc/cpuinfo; then
    modprobe kvm_intel || true
elif grep -q svm /proc/cpuinfo; then
    modprobe kvm_amd || true
fi
EOF
RUN chmod +x /usr/local/bin/firecracker-kvm-module.sh

RUN printf '%s\n' \
      '[Unit]' \
      'Description=Load the KVM vendor module for Firecracker' \
      'After=systemd-modules-load.service' \
      '' \
      '[Service]' \
      'Type=oneshot' \
      'Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
      'ExecStart=/usr/local/bin/firecracker-kvm-module.sh' \
      'RemainAfterExit=yes' \
      '' \
      '[Install]' \
      'WantedBy=multi-user.target' \
      > /etc/systemd/system/firecracker-kvm-module.service && \
    mkdir -p /etc/systemd/system/multi-user.target.wants && \
    ln -sf /etc/systemd/system/firecracker-kvm-module.service /etc/systemd/system/multi-user.target.wants/firecracker-kvm-module.service

RUN echo "${HOSTNAME}" > /etc/hostname
