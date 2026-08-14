#!/bin/bash
log() {
  echo "[worker] $1" >> /dev/kmsg
}

# fix kube-proxy(privileged): `failed to write "a *:* rwm" to devices.allow: operation not permitted`
log "fix cgroups"
umount /sys/fs/cgroup/devices
mount -t cgroup -o devices none /sys/fs/cgroup/devices

log "start kubelet"
systemctl enable --now kubelet.service

# Retry the join: the master recreates the bootstrap token in its init.sh and
# there is a small race window between the API becoming healthy and the token
# being recreated. The token is --ttl 0 (forever) on the master side, so a
# retry loop is the robust way to absorb that window.
log "kubeadm join"
join_attempts=0
until kubeadm join 10.0.2.16:6443 \
  --config /kind/kubeadm.conf \
  --skip-phases=preflight >> /dev/kmsg 2>&1; do
  join_attempts=$((join_attempts + 1))
  if [ "${join_attempts}" -ge 60 ]; then
    log "kubeadm join failed after 60 attempts, exiting"
    exit 1
  fi
  log "join failed, retrying in 10s"
  sleep 10
done
log "kubeadm join succeeded"

log "Waiting for at least one worker node to become Ready."
wait_start=$(date +%s)
until [ "$(kubectl get nodes -l '!node-role.kubernetes.io/master' --no-headers 2>/dev/null | grep -c ' Ready ' || true)" -ge 1 ]; do
  if [ $(($(date +%s) - wait_start)) -ge 1800 ]; then
    log "timeout waiting for worker Ready, exiting"
    exit 1
  fi
  sleep 3
done
log "worker node is Ready"

log "Waiting for all pods ready"
wait_attempts=0
until kubectl wait --for=condition=Ready pod --all -A --timeout=5s; do
  wait_attempts=$((wait_attempts + 1))
  if [ "${wait_attempts}" -ge 60 ]; then
    log "pods wait timeout, skipping"
    break
  fi
  sleep 1
done >>/dev/kmsg 2>&1

log "remove unused containers"
crictl rm $(crictl ps -a -q) >>/dev/kmsg 2>&1

log "prevent data lost"
sync

log "gracefully exit"
systemctl exit 0
