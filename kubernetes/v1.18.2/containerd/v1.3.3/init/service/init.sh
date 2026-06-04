#!/bin/bash
set -euo pipefail

HOSTNAME="kubernetes-1-18-2-containerd-1-3-3"

log() {
    echo "[dqd] $1" > /dev/kmsg
}

set_hostname() {
    log "Setting hostname"
    hostnamectl set-hostname "${HOSTNAME}" > /dev/kmsg 2>&1
}

mount_devices_cgroup() {
    log "Mounting cgroup v1 devices controller"
    if mountpoint -q /sys/fs/cgroup/devices; then
        umount /sys/fs/cgroup/devices > /dev/kmsg 2>&1 || true
    fi
    if ! mountpoint -q /sys/fs/cgroup/devices; then
        mount -t cgroup -o devices none /sys/fs/cgroup/devices > /dev/kmsg 2>&1
    fi
}

init_kubernetes() {
    log "kubeadm init"
    kubeadm init --skip-phases=preflight --config=/kind/kubeadm.conf --skip-token-print --v=6 > /dev/kmsg 2>&1
}

remove_taint() {
    log "Removing master taint"
    kubectl taint nodes --all node-role.kubernetes.io/master- > /dev/kmsg 2>&1
}

wait_kube_system_pods_created() {
    local max_wait_time=300
    local wait_interval=5
    local elapsed=0
    local pod_count

    log "Waiting for kube-system pods to be created"
    while true; do
        pod_count="$(kubectl get pods -n kube-system --no-headers 2>/dev/null | wc -l || true)"
        if [[ "${pod_count}" -ge 7 ]]; then
            log "Detected ${pod_count} kube-system pods created"
            break
        fi

        if (( elapsed >= max_wait_time )); then
            log "Timeout waiting for kube-system pods to be created"
            break
        fi

        sleep "${wait_interval}"
        elapsed=$((elapsed + wait_interval))
    done
}

wait_kube_system_pods_ready() {
    log "Waiting for kube-system pods to be ready"
    until kubectl wait --for=condition=Ready pod --all -A --field-selector=metadata.namespace=kube-system -l "k8s-app!=kube-dns" --timeout=5s; do
        sleep 1
    done >> /dev/kmsg 2>&1
}

sync_data() {
    log "Syncing data"
    sync
}

graceful_exit() {
    log "Gracefully exiting systemd"
    systemctl exit 0
}

set_hostname
mount_devices_cgroup
init_kubernetes
remove_taint
wait_kube_system_pods_created
wait_kube_system_pods_ready
sync_data
graceful_exit
