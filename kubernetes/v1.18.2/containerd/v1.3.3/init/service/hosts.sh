#!/bin/bash
set -euo pipefail

HOSTNAME="kubernetes-1-18-2-containerd-1-3-3"

IP="$(ip -4 addr show eth1 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1 || true)"
if [[ -z "${IP}" ]]; then
    IP="$(ip -4 addr show eth0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1 || true)"
fi
if [[ -z "${IP}" ]]; then
    echo "Error: Failed to get IP from either eth1 or eth0" >&2
    exit 1
fi

sed -i "/[[:space:]]${HOSTNAME}$/d" /etc/hosts
echo "${IP} ${HOSTNAME}" >> /etc/hosts
echo "hosts.sh: mapped ${IP} to ${HOSTNAME} in /etc/hosts"
