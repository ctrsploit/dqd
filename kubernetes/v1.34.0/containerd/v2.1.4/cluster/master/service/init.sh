#!/bin/bash

log() {
  echo "[master] $1" >> /dev/kmsg
}

# re-create the bootstrap token as early as possible: the calico base image
# may be days/weeks old, and bootstrap tokens expire after 24h by default.
# Doing this first shrinks the race window for the worker join (CI starts the
# worker build right after the API healthz probe succeeds).
log "recreate bootstrap token"
until kubeadm token create abcdef.0123456789abcdef --ttl 0 >>/dev/kmsg 2>&1; do
  sleep 2
done

# Fix the kube-proxy configmap: its kubeconfig server points at the build-time
# hostname (kubernetes-1-34-0-containerd-2-1-4), which pod containers cannot
# resolve at runtime (no --add-host in the QEMU VM). kube-proxy then fails its
# Node informer and never writes iptables rules, leaving service IPs
# (10.96.0.1) unreachable and cascading failures (calico CNI, pods Unknown).
# Rewrite to the master IP, which is valid both at build time and runtime.
log "fix kube-proxy configmap server address"
until kubectl -n kube-system get cm kube-proxy -o yaml 2>/dev/null | \
    sed 's|https://kubernetes-1-34-0-containerd-2-1-4:6443|https://10.0.2.16:6443|g' | \
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
until [ "$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' --no-headers 2>/dev/null | grep -c ' Ready ' || true)" -ge 1 ]; do
  if [ $(($(date +%s) - wait_start)) -ge 1800 ]; then
    log "timeout waiting for worker node, exiting"
    exit 1
  fi
  sleep 3
done
log "worker node is Ready"

# NOTE: intentionally do NOT wait for all pods here. In a calico cluster the
# worker node's Ready condition already implies its calico-node is running,
# and waiting on cluster-wide pods would deadlock: the worker sandbox exits
# right after its own init, which stops the worker kubelet and its pods.

log "remove unused containers"
crictl rm $(crictl ps -a -q) >>/dev/kmsg 2>&1

log "prevent data lost"
sync

log "gracefully exit"
systemctl exit 0
