# ============================================================================
# Configuration variables
# ============================================================================
ARG HOSTNAME=kata-4-3-1
ARG VERSION_KATA=4.3.1
ARG VERSION_DOCKER=29.9.2
ARG VERSION_IMAGE=0.1.0

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/docker-v${VERSION_DOCKER}-debian-13.7:ctr_v${VERSION_IMAGE}
ARG URL_KATA=https://github.com/kata-containers/kata-containers/releases/download/${VERSION_KATA}/kata-static-${VERSION_KATA}-amd64.tar.zst
ARG KATA_SHIM=/opt/kata/runtime-rs/bin/containerd-shim-kata-v2
ARG KATA_CONFIG=/opt/kata/share/defaults/kata-containers/runtime-rs/configuration-qemu-runtime-rs.toml

# ================================
# Build Stages
# ================================
FROM ${BASE_IMAGE}
ARG HOSTNAME
ARG URL_KATA
ARG KATA_SHIM
ARG KATA_CONFIG

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    zstd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "${URL_KATA}" -o /tmp/kata.tar.zst && \
    tar --zstd -xf /tmp/kata.tar.zst -C / && \
    rm -f /tmp/kata.tar.zst && \
    test -x "${KATA_SHIM}" && \
    test -f "${KATA_CONFIG}"

# Keep the Kata guest small enough for the 2 GiB dqd lab VM.
RUN CFG="${KATA_CONFIG}" && \
    sed -i -E 's/^([[:space:]]*default_memory[[:space:]]*=).*/\1 512/' "$CFG" && \
    sed -i -E 's/^([[:space:]]*default_vcpus[[:space:]]*=).*/\1 1/' "$CFG" && \
    grep -qE '^[[:space:]]*default_memory[[:space:]]*=' "$CFG"

# Register the Kata runtime-rs shim as a Docker runtime.
RUN mkdir -p /etc/docker && \
    printf '%s\n' \
      '{' \
      '  "runtimes": {' \
      '    "kata": {' \
      '      "runtimeType": "/opt/kata/runtime-rs/bin/containerd-shim-kata-v2",' \
      '      "options": {' \
      '        "ConfigPath": "/opt/kata/share/defaults/kata-containers/runtime-rs/configuration-qemu-runtime-rs.toml"' \
      '      }' \
      '    }' \
      '  }' \
      '}' > /etc/docker/daemon.json

# Kata needs vhost-vsock/vhost-net and a usable nested KVM module.
RUN cat > /usr/local/bin/kata-modules.sh <<'EOF'
#!/bin/sh
set -u
modprobe vhost_vsock || true
modprobe vhost_net || true
if grep -q vmx /proc/cpuinfo; then
    modprobe kvm_intel || true
elif grep -q svm /proc/cpuinfo; then
    modprobe kvm_amd || true
fi
EOF
RUN chmod +x /usr/local/bin/kata-modules.sh

RUN printf '%s\n' \
      '[Unit]' \
      'Description=Load modules required by Kata Containers' \
      'After=systemd-modules-load.service' \
      'Before=docker.service' \
      '' \
      '[Service]' \
      'Type=oneshot' \
      'Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
      'ExecStart=/usr/local/bin/kata-modules.sh' \
      'RemainAfterExit=yes' \
      '' \
      '[Install]' \
      'WantedBy=multi-user.target' \
      > /etc/systemd/system/kata-modules.service && \
    mkdir -p /etc/systemd/system/multi-user.target.wants && \
    ln -sf /etc/systemd/system/kata-modules.service /etc/systemd/system/multi-user.target.wants/kata-modules.service

RUN echo "${HOSTNAME}" > /etc/hostname
