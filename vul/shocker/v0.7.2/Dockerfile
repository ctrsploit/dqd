ARG HOSTNAME=shocker-v0-7-2
FROM ghcr.io/ctrsploit/docker-v0.7.2:ctr_v0.1.0
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname

COPY busybox-ubuntu-12.04.tar.gz /root/
COPY poc.sh /root/
