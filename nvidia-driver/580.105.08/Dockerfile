# ============================================================================
# Configuration variables
# ============================================================================
# Ubuntu 24.04 dqd distro layer (same base as the other dqd environments).
ARG VERSION_UBUNTU=0.4.0
# Kernel the modules are built for; dqd converts this image with KERNEL=false
# in the consumer environment, so this kernel is the one that boots.
ARG VERSION_KERNEL=6.8.0-101
ARG VERSION_KERNEL_BUILD=6.8.0-101.101
# NVIDIA open kernel module build. 580.105.08 is the vulnerable build for
# CVE-2026-47595 (fixed in 580.178.04); see the reference project
# gsp-emulator/docs/STAGE5-fix-comparison.
ARG VERSION_NVIDIA=580.105.08
ARG SHA256_NVIDIA=d9c6e8188672f3eb74dd04cfa69dd58479fa1d0162c8c28c8d17625763293475

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/ubuntu-24.04:ctr_v${VERSION_UBUNTU}
ARG URL_KERNEL_BASE=https://security.ubuntu.com/ubuntu/pool/main/l
ARG URL_KERNEL_IMAGE=${URL_KERNEL_BASE}/linux-signed/linux-image-${VERSION_KERNEL}-generic_${VERSION_KERNEL_BUILD}_amd64.deb
ARG URL_KERNEL_MODULES=${URL_KERNEL_BASE}/linux/linux-modules-${VERSION_KERNEL}-generic_${VERSION_KERNEL_BUILD}_amd64.deb
ARG URL_KERNEL_MODULES_EXTRA=${URL_KERNEL_BASE}/linux/linux-modules-extra-${VERSION_KERNEL}-generic_${VERSION_KERNEL_BUILD}_amd64.deb
ARG URL_KERNEL_HEADERS=${URL_KERNEL_BASE}/linux/linux-headers-${VERSION_KERNEL}-generic_${VERSION_KERNEL_BUILD}_amd64.deb
ARG URL_KERNEL_HEADERS_COMMON=${URL_KERNEL_BASE}/linux/linux-headers-${VERSION_KERNEL}_${VERSION_KERNEL_BUILD}_all.deb
ARG URL_NVIDIA=https://us.download.nvidia.com/XFree86/Linux-x86_64/${VERSION_NVIDIA}/NVIDIA-Linux-x86_64-${VERSION_NVIDIA}.run

# ================================
# Build stages
# ================================
FROM ${BASE_IMAGE}
ARG VERSION_KERNEL
ARG VERSION_KERNEL_BUILD
ARG VERSION_NVIDIA
ARG SHA256_NVIDIA
ARG URL_KERNEL_IMAGE
ARG URL_KERNEL_MODULES
ARG URL_KERNEL_MODULES_EXTRA
ARG URL_KERNEL_HEADERS
ARG URL_KERNEL_HEADERS_COMMON
ARG URL_NVIDIA

# Toolchain and kernel package runtime dependencies. The build toolchain and
# the kernel headers stay in the image: the GSP harness layer compiles
# nvharness.ko against the same headers, and having them on hand is what makes
# the module/driver rebuild path usable inside the lab VM.
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    initramfs-tools \
    kmod \
    libelf-dev \
    xz-utils && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Pinned Ubuntu 24.04 generic kernel, from the security archive pool so an
# exact ABI stays downloadable after it is superseded in the apt indexes.
# linux-modules-extra carries crypto/ecc.ko, which the driver's UVM stack
# preloads on module setup.
RUN TMP_DIR="$(mktemp -d)" && \
    curl -fsSL "${URL_KERNEL_IMAGE}" -o "${TMP_DIR}/linux-image.deb" && \
    curl -fsSL "${URL_KERNEL_MODULES}" -o "${TMP_DIR}/linux-modules.deb" && \
    curl -fsSL "${URL_KERNEL_MODULES_EXTRA}" -o "${TMP_DIR}/linux-modules-extra.deb" && \
    curl -fsSL "${URL_KERNEL_HEADERS}" -o "${TMP_DIR}/linux-headers-generic.deb" && \
    curl -fsSL "${URL_KERNEL_HEADERS_COMMON}" -o "${TMP_DIR}/linux-headers-common.deb" && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends "${TMP_DIR}"/*.deb && \
    apt clean && \
    rm -rf "${TMP_DIR}" /var/lib/apt/lists/*

# Extract the official package, then build the unmodified open kernel modules.
# The installer is never run: no DKMS, no userspace driver library, no initramfs
# hook. KERNEL_UNAME pins the build target because uname -r inside a container
# is the *host* kernel, not the kernel installed above. Only the two modules the
# UVM path needs are built; the source tree and the 397 MB package are removed
# in the same layer.
RUN TMP_DIR="$(mktemp -d)" && \
    curl -fsSL "${URL_NVIDIA}" -o "${TMP_DIR}/NVIDIA.run" && \
    echo "${SHA256_NVIDIA}  ${TMP_DIR}/NVIDIA.run" | sha256sum -c - && \
    sh "${TMP_DIR}/NVIDIA.run" -x --target "${TMP_DIR}/nvsrc" && \
    mkdir -p "/lib/firmware/nvidia/${VERSION_NVIDIA}" && \
    cp "${TMP_DIR}"/nvsrc/firmware/gsp_*.bin "/lib/firmware/nvidia/${VERSION_NVIDIA}/" && \
    make -C "${TMP_DIR}/nvsrc/kernel-open" \
         KERNEL_UNAME="${VERSION_KERNEL}-generic" \
         NV_KERNEL_MODULES="nvidia nvidia-uvm" \
         modules && \
    mkdir -p "/opt/nvidia/${VERSION_NVIDIA}" && \
    cp "${TMP_DIR}/nvsrc/kernel-open/nvidia.ko" \
       "${TMP_DIR}/nvsrc/kernel-open/nvidia-uvm.ko" \
       "/opt/nvidia/${VERSION_NVIDIA}/" && \
    cd "/opt/nvidia/${VERSION_NVIDIA}" && \
    sha256sum nvidia.ko nvidia-uvm.ko > SHA256SUMS && \
    printf '%s\n' \
        'NVIDIA open kernel modules, built unmodified from the official package.' \
        '' \
        "package: NVIDIA-Linux-x86_64-${VERSION_NVIDIA}.run" \
        "url:     ${URL_NVIDIA}" \
        "sha256:  ${SHA256_NVIDIA}" \
        "kernel:  ${VERSION_KERNEL}-generic (${VERSION_KERNEL_BUILD})" \
        "build:   make -C kernel-open KERNEL_UNAME=${VERSION_KERNEL}-generic NV_KERNEL_MODULES=\"nvidia nvidia-uvm\" modules" \
        > SOURCES.md && \
    rm -rf "${TMP_DIR}"

# Build-time contract for every consumer of this image: the pinned kernel, its
# headers, the GSP firmware staged under /lib/firmware for a GSP boot model, and
# open modules whose vermagic matches the kernel. Ubuntu ships modules
# compressed (.ko.zst) and modprobe resolves them by name, so both the file and
# the modprobe lookup are checked.
RUN test -n "$(ls /lib/firmware/nvidia/${VERSION_NVIDIA}/gsp_*.bin)" && \
    test -f "/lib/modules/${VERSION_KERNEL}-generic/build/Makefile" && \
    test -f "/lib/modules/${VERSION_KERNEL}-generic/kernel/crypto/ecc.ko.zst" && \
    modprobe -S "${VERSION_KERNEL}-generic" -n ecc && \
    test -f "/opt/nvidia/${VERSION_NVIDIA}/nvidia.ko" && \
    test -f "/opt/nvidia/${VERSION_NVIDIA}/nvidia-uvm.ko" && \
    test "$(modinfo -F version "/opt/nvidia/${VERSION_NVIDIA}/nvidia.ko")" = "${VERSION_NVIDIA}" && \
    test "$(modinfo -F version "/opt/nvidia/${VERSION_NVIDIA}/nvidia-uvm.ko")" = "${VERSION_NVIDIA}" && \
    modinfo -F vermagic "/opt/nvidia/${VERSION_NVIDIA}/nvidia.ko" | grep -q "^${VERSION_KERNEL}-generic "
