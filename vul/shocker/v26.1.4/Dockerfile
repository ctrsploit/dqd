ARG HOSTNAME=shocker-v26-1-4
FROM ghcr.io/ctrsploit/docker-v26.1.4:ctr_v0.1.0
ARG HOSTNAME
RUN echo ${HOSTNAME} > /etc/hostname

COPY flag /root/
COPY poc.sh /root/
