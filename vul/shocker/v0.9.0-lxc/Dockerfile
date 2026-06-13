ARG HOSTNAME=shocker-v0-9-0-lxc
FROM ghcr.io/ctrsploit/docker-v0.9.0:ctr_v0.1.0
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname

COPY busybox-ubuntu-12.04.tar.gz /root/
COPY poc.sh /root/
