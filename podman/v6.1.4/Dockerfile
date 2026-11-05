# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=podman-6-1-4
ARG VERSION_PODMAN=6.1.4
ARG VERSION_PODMAN_STACK=6.1.3
ARG VERSION_FEDORA=45
ARG VERSION_IMAGE=0.1.0
ARG VERSION_GO=1.26-bookworm

# ================================
# Internal Variables
# ================================
# podman 6.1.4's native distro set is Fedora 45: the f45 release set ships
# podman 6.1.3 and its 6.1-era companion stack (crun, conmon,
# netavark/aardvark-dns, containers-common). The podman-6.1.4-1.fc45 rpm
# exists in Fedora koji, but kojipkgs/koji/bodhi sit behind an anti-bot
# challenge that blocks automated fetches from CI, and the f45 updates
# mirror no longer carries any podman build. So the companion stack is
# installed from the f45 release repos (dnf podman-6.1.3) and only the
# /usr/bin/podman binary is replaced with a source build of upstream 6.1.4,
# together with the matching rootlessport helper. No version pins beyond
# the stack itself.
ARG BASE_IMAGE=ghcr.io/ctrsploit/fedora-${VERSION_FEDORA}:ctr_v${VERSION_IMAGE}
ARG URL_ARTIFACT_PODMAN=https://github.com/containers/podman/archive/refs/tags/v${VERSION_PODMAN}.tar.gz

# ================================
# Build Stages
# ================================
FROM golang:${VERSION_GO} AS builder
ARG URL_ARTIFACT_PODMAN
ADD ${URL_ARTIFACT_PODMAN} /tmp/podman.tar.gz
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libseccomp-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /src/podman && \
    tar -xzf /tmp/podman.tar.gz -C /src/podman --strip-components=1 && \
    cd /src/podman && \
    make bin/podman BUILDTAGS="seccomp exclude_graphdriver_btrfs exclude_graphdriver_devicemapper containers_image_openpgp" && \
    # seccomp MUST be in BUILDTAGS: passing a custom BUILDTAGS replaces the
    # Makefile default, and without the tag podman builds with seccomp support
    # compiled out and every container start dies with
    # "loading seccomp profile (...) failed: seccomp not enabled in this build".
    make bin/rootlessport && \
    ./bin/podman --version

FROM ${BASE_IMAGE} AS stack
ARG VERSION_PODMAN_STACK
RUN dnf -y install \
    podman-${VERSION_PODMAN_STACK} && \
    dnf clean all

FROM stack AS rootless
ARG HOSTNAME
COPY --from=builder /src/podman/bin/podman /usr/bin/podman
COPY --from=builder /src/podman/bin/rootlessport /usr/libexec/podman/rootlessport
RUN chmod 755 /usr/bin/podman /usr/libexec/podman/rootlessport
# Enable writing /proc/[pid]/uid_map and /proc/[pid]/gid_map for rootless podman.
RUN chmod 4755 /usr/bin/newuidmap /usr/bin/newgidmap
RUN useradd -m -U -d /home/user -s /bin/bash user
RUN mkdir -p /var/lib/systemd/linger && \
    touch /var/lib/systemd/linger/user && \
    chmod 644 /var/lib/systemd/linger/user
RUN echo ${HOSTNAME} > /etc/hostname
