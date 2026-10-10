# ================================
# Configuration Variables
# ================================
ARG HOSTNAME=podman-3-0-1
ARG VERSION_IMAGE_UBUNTU=0.3.0

# ================================
# Internal Variables
# ================================
ARG IMAGE_UBUNTU=ghcr.io/ctrsploit/ubuntu-20.04:ctr_v${VERSION_IMAGE_UBUNTU}
# The podman 3.0.1 stack from Debian bullseye (glibc 2.31, same as focal):
# the exact runc-rc93-era stack bullseye users ran when CVE-2021-30465 was
# disclosed (Debian bug #988768). deb.debian.org pool URLs are immutable.
# NOTE: bullseye's runc package is deliberately NOT installed -- its
# deb11u3+ revisions backport the CVE-2021-30465 fix; crun 0.17 satisfies
# podman's "crun | runc" runtime dependency instead.
ARG URL_DEB_PODMAN=http://deb.debian.org/debian/pool/main/libp/libpod/podman_3.0.1+dfsg1-3+deb11u5_amd64.deb
ARG URL_DEB_CONMON=http://deb.debian.org/debian/pool/main/c/conmon/conmon_2.0.25+ds1-1.1+deb11u1_amd64.deb
ARG URL_DEB_CATATONIT=http://deb.debian.org/debian/pool/main/c/catatonit/catatonit_0.1.5-2_amd64.deb
ARG URL_DEB_CNI_PLUGINS=http://deb.debian.org/debian/pool/main/g/golang-github-containernetworking-plugins/containernetworking-plugins_0.9.0-1+b6_amd64.deb
ARG URL_DEB_CONTAINERS_COMMON=http://deb.debian.org/debian/pool/main/g/golang-github-containers-common/golang-github-containers-common_0.33.4+ds1-1+deb11u2_all.deb
ARG URL_DEB_CONTAINERS_IMAGE=http://deb.debian.org/debian/pool/main/g/golang-github-containers-image/golang-github-containers-image_5.10.3-1_all.deb
ARG URL_DEB_CRUN=http://deb.debian.org/debian/pool/main/c/crun/crun_0.17+dfsg-1+deb11u2_amd64.deb

# ================================
# Build Stages
# ================================
FROM ${IMAGE_UBUNTU}
ARG HOSTNAME
ARG URL_DEB_PODMAN
ARG URL_DEB_CONMON
ARG URL_DEB_CATATONIT
ARG URL_DEB_CNI_PLUGINS
ARG URL_DEB_CONTAINERS_COMMON
ARG URL_DEB_CONTAINERS_IMAGE
ARG URL_DEB_CRUN
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libseccomp2 libgpgme11 libdevmapper1.02.1 libglib2.0-0 libcap2 libyajl2 \
      iptables && \
    rm -rf /var/lib/apt/lists/*
ADD ${URL_DEB_PODMAN} /tmp/debs/
ADD ${URL_DEB_CONMON} /tmp/debs/
ADD ${URL_DEB_CATATONIT} /tmp/debs/
ADD ${URL_DEB_CNI_PLUGINS} /tmp/debs/
ADD ${URL_DEB_CONTAINERS_COMMON} /tmp/debs/
ADD ${URL_DEB_CONTAINERS_IMAGE} /tmp/debs/
ADD ${URL_DEB_CRUN} /tmp/debs/
RUN dpkg -i /tmp/debs/*.deb && rm -rf /tmp/debs && \
    echo "${HOSTNAME}" > /etc/hostname
