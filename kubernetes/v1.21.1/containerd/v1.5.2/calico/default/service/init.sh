#!/bin/bash
set -euo pipefail

log() {
  echo "[dqd] $1" >> /dev/kmsg
}

mount_devices_cgroup() {
  log "Mounting cgroup v1 devices controller"
  if mountpoint -q /sys/fs/cgroup/devices; then
    umount /sys/fs/cgroup/devices >> /dev/kmsg 2>&1 || true
  fi
  if ! mountpoint -q /sys/fs/cgroup/devices; then
    mount -t cgroup -o devices none /sys/fs/cgroup/devices >> /dev/kmsg 2>&1
  fi
}

start_kubelet() {
  log "Starting kubelet"
  systemctl enable --now kubelet >> /dev/kmsg 2>&1
}

wait_kube_system_pods_ready() {
  log "Waiting for kube-system pods to be ready"
  until kubectl wait --for=condition=Ready pod --all -A --field-selector=metadata.namespace=kube-system -l "k8s-app!=kube-dns" --timeout=5s; do
    sleep 1
  done >>/dev/kmsg 2>&1
  log "kube-system pods are ready"
}

install_calico_network() {
  log "Installing Calico network addon"
  # https://docs.tigera.io/archive/v3.19/getting-started/kubernetes/requirements#kernel-dependencies
  kubectl create -f https://docs.projectcalico.org/archive/v3.19/manifests/tigera-operator.yaml >>/dev/kmsg 2>&1
  kubectl create -f https://docs.projectcalico.org/archive/v3.19/manifests/custom-resources.yaml >>/dev/kmsg 2>&1
  log "Calico network addon installed"
}

wait_all_pods_ready() {
  log "Waiting for all pods to be ready"
  until kubectl wait --for=condition=Ready pod --all -A --timeout=5s; do
    sleep 1
  done >>/dev/kmsg 2>&1
  log "All pods are ready"
}

cleanup_unused_containers() {
  log "Removing unused containers"
  crictl rm $(crictl ps -a -q) >>/dev/kmsg 2>&1 || true
  log "Unused containers removed"
}

sync_data() {
  log "Syncing data to prevent data loss"
  sync
  log "Data synced"
}

graceful_exit() {
  log "Gracefully exiting systemd"
  systemctl exit 0
}

mount_devices_cgroup
start_kubelet
wait_kube_system_pods_ready
install_calico_network
wait_all_pods_ready
cleanup_unused_containers
sync_data
graceful_exit
