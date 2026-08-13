#!/bin/bash
log() {
  echo "[worker] $1" >> /dev/kmsg
}

log "kubeadm join"
# Retry the join: the master recreates the bootstrap token in its init.sh and
# there is a small race window between the API becoming healthy and the token
# being recreated. The token is --ttl 0 (forever) on the master side, so a
# retry loop is the robust way to absorb that window.
join_attempts=0
until kubeadm join 10.0.2.16:6443 --skip-phases=preflight \
  --token abcdef.0123456789abcdef \
  --discovery-token-unsafe-skip-ca-verification >> /dev/kmsg 2>&1; do
  join_attempts=$((join_attempts + 1))
  if [ "${join_attempts}" -ge 60 ]; then
    log "kubeadm join failed after 60 attempts, exiting"
    exit 1
  fi
  log "join failed, retrying in 10s"
  sleep 10
done
log "kubeadm join succeeded"
# kubeadm join --config /kind/kubeadm.conf

# Wait for the local calico-node container instead of cluster-wide pods:
# a cluster-wide kubectl wait would depend on the master sandbox staying
# alive, but the master build exits as soon as it sees this node Ready,
# destroying its API server and hanging this loop forever.
log "waiting for local calico-node container to be Running"
wait_attempts=0
until crictl ps --name calico-node 2>/dev/null | grep -q Running; do
  wait_attempts=$((wait_attempts + 1))
  if [ "${wait_attempts}" -ge 240 ]; then
    log "timeout waiting for local calico-node, exiting"
    exit 1
  fi
  sleep 5
done
log "local calico-node is Running"

log "remove unused containers"
crictl rm $(crictl ps -a -q) >>/dev/kmsg 2>&1

log "prevent data lost"
sync

log "gracefully exit"
systemctl exit 0
