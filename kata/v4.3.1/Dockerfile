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

# The official install extracts the full kata-static bundle. Keep only the
# QEMU runtime-rs pieces this lab uses (drops openvmm, debug/nvidia/mariner
# kernels and images, and the extra VMM builds).
RUN set -eux; \
    curl -fsSL "${URL_KATA}" -o /tmp/kata.tar.zst; \
    tar --zstd -xf /tmp/kata.tar.zst -C /; \
    rm -f /tmp/kata.tar.zst; \
    mkdir -p /opt/kata-keep/bin \
             /opt/kata-keep/runtime-rs/bin \
             /opt/kata-keep/libexec \
             /opt/kata-keep/lib \
             /opt/kata-keep/share/kata-containers \
             /opt/kata-keep/share/kata-qemu \
             /opt/kata-keep/share/defaults/kata-containers/runtime-rs; \
    cp -a /opt/kata/bin/qemu-system-x86_64 /opt/kata-keep/bin/; \
    cp -a /opt/kata/runtime-rs/bin/containerd-shim-kata-v2 /opt/kata-keep/runtime-rs/bin/; \
    cp -a /opt/kata/libexec/virtiofsd /opt/kata-keep/libexec/; \
    cp -a /opt/kata/lib/. /opt/kata-keep/lib/; \
    cp -a /opt/kata/share/kata-qemu/. /opt/kata-keep/share/kata-qemu/; \
    cp -a /opt/kata/share/kata-containers/vmlinux.container /opt/kata-keep/share/kata-containers/; \
    cp -a "$(readlink -f /opt/kata/share/kata-containers/vmlinux.container)" /opt/kata-keep/share/kata-containers/; \
    cp -a /opt/kata/share/kata-containers/kata-containers.img /opt/kata-keep/share/kata-containers/; \
    cp -a "$(readlink -f /opt/kata/share/kata-containers/kata-containers.img)" /opt/kata-keep/share/kata-containers/; \
    cp -a /opt/kata/share/kata-containers/root_hash_base.txt /opt/kata-keep/share/kata-containers/; \
    cp -a /opt/kata/share/defaults/kata-containers/runtime-rs/configuration-qemu-runtime-rs.toml /opt/kata-keep/share/defaults/kata-containers/runtime-rs/; \
    rm -rf /opt/kata; \
    mv /opt/kata-keep /opt/kata; \
    test -x "${KATA_SHIM}"; \
    test -f "${KATA_CONFIG}"; \
    test -x /opt/kata/libexec/virtiofsd; \
    test -e /opt/kata/share/kata-containers/vmlinux.container; \
    test -e /opt/kata/share/kata-containers/kata-containers.img

# Use the documented per-host override; /etc/kata-containers/configuration.toml
# takes precedence over the packaged defaults. Keep the guest small enough for
# the 2 GiB dqd lab VM.
RUN mkdir -p /etc/kata-containers && \
    cp "${KATA_CONFIG}" /etc/kata-containers/configuration.toml && \
    sed -i -E 's/^([[:space:]]*default_memory[[:space:]]*=).*/\1 512/' /etc/kata-containers/configuration.toml && \
    sed -i -E 's/^([[:space:]]*default_vcpus[[:space:]]*=).*/\1 1/' /etc/kata-containers/configuration.toml && \
    grep -qE '^[[:space:]]*default_memory[[:space:]]*=' /etc/kata-containers/configuration.toml

# Register the Kata runtime-rs shim as a Docker runtime.
RUN mkdir -p /etc/docker && \
    printf '%s\n' \
      '{' \
      '  "runtimes": {' \
      '    "kata": {' \
      '      "runtimeType": "/opt/kata/runtime-rs/bin/containerd-shim-kata-v2",' \
      '      "options": {' \
      '        "ConfigPath": "/etc/kata-containers/configuration.toml"' \
      '      }' \
      '    }' \
      '  }' \
      '}' > /etc/docker/daemon.json

# Official host prerequisite: persist the vhost modules via modules-load.d.
RUN printf '%s\n' vhost_vsock vhost_net > /etc/modules-load.d/kata-containers.conf

# dqd starts the lab VM with -cpu host; load the matching KVM vendor module.
RUN cat > /usr/local/bin/kata-kvm-module.sh <<'EOF'
#!/bin/sh
set -u
if grep -q vmx /proc/cpuinfo; then
    modprobe kvm_intel || true
elif grep -q svm /proc/cpuinfo; then
    modprobe kvm_amd || true
fi
EOF
RUN chmod +x /usr/local/bin/kata-kvm-module.sh

RUN printf '%s\n' \
      '[Unit]' \
      'Description=Load the KVM vendor module for Kata Containers' \
      'After=systemd-modules-load.service' \
      'Before=docker.service' \
      '' \
      '[Service]' \
      'Type=oneshot' \
      'Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
      'ExecStart=/usr/local/bin/kata-kvm-module.sh' \
      'RemainAfterExit=yes' \
      '' \
      '[Install]' \
      'WantedBy=multi-user.target' \
      > /etc/systemd/system/kata-kvm-module.service && \
    mkdir -p /etc/systemd/system/multi-user.target.wants && \
    ln -sf /etc/systemd/system/kata-kvm-module.service /etc/systemd/system/multi-user.target.wants/kata-kvm-module.service

RUN echo "${HOSTNAME}" > /etc/hostname
