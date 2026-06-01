ARG HOSTNAME=runc-centos-stream9-v1-3-0-rc-1-selinux
ARG VERSION_RUNC=1.3.0-rc.1
ARG VERSION_IMAGE=0.1.0
ARG BASE_IMAGE=ghcr.io/ctrsploit/centos-stream9-runc-v${VERSION_RUNC}:ctr_v${VERSION_IMAGE}

FROM ${BASE_IMAGE}
ARG HOSTNAME
RUN dnf install -y selinux-policy selinux-policy-targeted policycoreutils policycoreutils-python-utils && dnf clean all && rm -rf /var/cache/dnf/* && touch /.autorelabel
RUN echo "${HOSTNAME}" > /etc/hostname
