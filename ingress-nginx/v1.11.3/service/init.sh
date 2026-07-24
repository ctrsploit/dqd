#!/bin/bash

# The kubeconfig (/etc/kubernetes/admin.conf) reaches the API server via the
# controlPlaneEndpoint hostname "kubernetes-1-32-3-containerd-2-0-3" baked in
# by kubeadm.conf. Under buildkit --security=insecure exec, /etc/hosts is a
# READ-ONLY bind mount, so hosts.service's hosts.sh (sed -i /etc/hosts) fails
# and the hostname is never mapped -- kubectl falls through to DNS (8.8.8.8)
# and fails with "no such host". Remount /etc/hosts rw and add the mapping so
# kubelet/kubectl can reach the API server. (kube-apiserver binds 10.0.2.16:6443,
# the advertiseAddress the build container owns on docker-archive-bridge.)
CP_HOSTNAME="kubernetes-1-32-3-containerd-2-0-3"
if ! getent hosts "${CP_HOSTNAME}" >/dev/null 2>&1; then
  mount -o remount,rw /etc/hosts 2>/dev/null || true
  echo "10.0.2.16 ${CP_HOSTNAME}" >>/etc/hosts 2>/dev/null || true
fi

# wait pods ready
until kubectl wait --for=condition=Ready pod --all -A --timeout=5s; do sleep 1; done >>/dev/kmsg 2>&1

# install ingress-nginx
# https://kubernetes.github.io/ingress-nginx/deploy/#quick-start
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/cloud/deploy.yaml >>/dev/kmsg 2>&1

# wait pods ready
until kubectl wait --for=condition=Ready pod --all -A --field-selector=status.phase!=Succeeded --timeout=5s; do sleep 1; done >>/dev/kmsg 2>&1

# remove unused containers
crictl rm $(crictl ps -a -q) >>/dev/kmsg 2>&1

# prevent data lost
sync

# gracefully exit
systemctl exit 0
