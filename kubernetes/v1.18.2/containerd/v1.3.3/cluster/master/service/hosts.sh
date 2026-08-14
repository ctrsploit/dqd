#!/bin/bash
HOSTNAME="kubernetes-1-18-2"
# the dqd base image's kube configs point at this hostname (its build-time
# name); map both so in-VM kubectl works at runtime
DQD_HOSTNAME="kubernetes-1-18-2-containerd-1-3-3"

IP=$(ip -4 addr show eth1 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)
if [ -z "$IP" ]; then
  IP=$(ip -4 addr show eth0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)
fi
if [ -z "$IP" ]; then
  echo "Error: Failed to get IP from either eth1 or eth0" >&2
  exit 1
fi
sed -i "/[[:space:]]${HOSTNAME}$/d" /etc/hosts
sed -i "/[[:space:]]${DQD_HOSTNAME}$/d" /etc/hosts
echo "$IP ${HOSTNAME}" >> /etc/hosts
echo "$IP ${DQD_HOSTNAME}" >> /etc/hosts
echo "hosts.sh: Successfully mapped second IP $IP to $HOSTNAME and $DQD_HOSTNAME in /etc/hosts"
