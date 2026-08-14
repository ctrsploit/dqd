#!/bin/bash

log() {
  echo "[master] $1" >> /dev/kmsg
}

# fix kube-proxy(privileged): `failed to write "a *:* rwm" to devices.allow: operation not permitted`
log "fix cgroups"
umount /sys/fs/cgroup/devices
mount -t cgroup -o devices none /sys/fs/cgroup/devices

log "start kubelet"
systemctl enable --now kubelet

# re-create the bootstrap token: the calico base image may be days/weeks old,
# and bootstrap tokens expire after 24h by default. Doing this first shrinks
# the race window for the worker join.
log "recreate bootstrap token"
until kubeadm token create abcdef.0123456789abcdef --ttl 0 >>/dev/kmsg 2>&1; do
  sleep 2
done

# Fix the kube-proxy configmap: its kubeconfig server points at the build-time
# hostname, which pod containers cannot resolve at runtime (no --add-host in
# the QEMU VM). kube-proxy then never writes iptables rules, leaving service
# IPs unreachable and cascading failures (calico CNI, pods Unknown). Rewrite
# to the master IP, valid both at build time and runtime.
log "fix kube-proxy configmap server address"
until kubectl -n kube-system get cm kube-proxy -o yaml 2>/dev/null | \
    sed 's|https://kubernetes-1-18-2-containerd-1-3-3:6443|https://10.0.2.16:6443|g' | \
    kubectl replace -f - >>/dev/kmsg 2>&1; do
  sleep 2
done
log "kube-proxy configmap fixed"

log "wait pods ready"
# Only wait for kube-system (control-plane) pods: the worker joins while this
# loop runs, and its pods appear/disappear with the worker sandbox lifecycle,
# so a cluster-wide wait would never stabilize.
until kubectl wait --for=condition=Ready pod --all -A --field-selector=metadata.namespace=kube-system --timeout=5s; do sleep 1; done >>/dev/kmsg 2>&1

log "Waiting for at least one worker node to become Ready."
wait_start=$(date +%s)
until [ "$(kubectl get nodes -l '!node-role.kubernetes.io/master' --no-headers 2>/dev/null | grep -c ' Ready ' || true)" -ge 1 ]; do
  if [ $(($(date +%s) - wait_start)) -ge 1800 ]; then
    log "timeout waiting for worker node, exiting"
    exit 1
  fi
  sleep 3
done
log "worker node is Ready"

log "Waiting for all pods ready"
until kubectl wait --for=condition=Ready pod --all -A --timeout=5s; do sleep 1; done >>/dev/kmsg 2>&1

log "Waiting for all worker nodes to become NotReady."
wait_start=$(date +%s)
until [ "$(kubectl get nodes -l '!node-role.kubernetes.io/master' --no-headers 2>/dev/null | grep -c ' NotReady ' || true)" -ge 1 ]; do
  if [ $(($(date +%s) - wait_start)) -ge 900 ]; then
    log "timeout waiting for worker down, exiting"
    exit 1
  fi
  sleep 3
done
log "worker node is NotReady"

log "remove unused containers"
crictl rm $(crictl ps -a -q) >>/dev/kmsg 2>&1

log "prevent data lost"
sync

log "gracefully exit"
systemctl exit 0
