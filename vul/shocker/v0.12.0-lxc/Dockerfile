ARG HOSTNAME=shocker-v0-12-0-lxc
FROM ghcr.io/ctrsploit/docker-v0.12.0-lxc:ctr_v0.1.0
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname

COPY busybox-1.36.1.tar.gz /root/
COPY poc.sh /root/
