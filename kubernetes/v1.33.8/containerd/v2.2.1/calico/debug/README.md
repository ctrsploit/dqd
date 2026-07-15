# Kubernetes v1.33.8 with Containerd v2.2.1 (Calico, Debug)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico_debug:latest | -> `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico_debug:v0.1.0 | debug kubelet,containerd |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico_debug:ctr_v0.1.0 | - |

## Usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.8/containerd/v2.2.1/calico/debug
$ ssh dqd-kubernetes-v1.33.8_containerd-v2.2.1_calico_debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.8/containerd/v2.2.1/calico/debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug Kubelet with Delve

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl stop kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# ln -sf /usr/local/bin/debug.sh /usr/bin/kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl start kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# journalctl -u kubelet -f
API server listening at: [::]:2345
...
```

### Debug Containerd with Delve

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl stop containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# ln -sf /usr/local/bin/debug.sh /usr/local/bin/containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# /usr/local/bin/containerd --config /etc/containerd/config.toml
API server listening at: [::]:2346
...
```

> Using `systemctl start containerd` is also ok, but will raise a systemctl's timeout error. It's as an expected behavior, because `containerd.service` uses `Type=notify`, and launching containerd via Delve can cause systemd startup timeout.

### GoLand remote attach

kubelet

```text
Run/Debug Configurations -> Go Remote
Host: 127.0.0.1
Port: 13386
```

containerd

```text
Run/Debug Configurations -> Go Remote
Host: 127.0.0.1
Port: 13387
```

### Restore Kubelet

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl stop kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# cp /usr/local/bin/kubelet.real /usr/bin/kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# chmod +x /usr/bin/kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl start kubelet
```

### Restore Containerd

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl stop containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# cp /usr/local/bin/containerd.real /usr/local/bin/containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# chmod +x /usr/local/bin/containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl start containerd
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-78fc8ccbf5-4lnp9                            1/1     Running   1 (4m23s ago)   18h
calico-apiserver   calico-apiserver-78fc8ccbf5-grwq8                            1/1     Running   1 (4m23s ago)   18h
calico-system      calico-kube-controllers-59df557df8-lq7nd                     1/1     Running   1 (4m23s ago)   18h
calico-system      calico-node-b54sq                                            1/1     Running   1 (4m23s ago)   18h
calico-system      calico-typha-85f6559796-66ggn                                1/1     Running   1 (4m23s ago)   18h
calico-system      csi-node-driver-qsxnx                                        2/2     Running   2 (4m23s ago)   18h
calico-system      goldmane-b49dd46d7-hnz9m                                     1/1     Running   1 (4m23s ago)   18h
calico-system      whisker-555567d487-2bhxq                                     2/2     Running   2 (4m23s ago)   18h
kube-system        coredns-674b8bbfcf-nt7wv                                     1/1     Running   1 (4m23s ago)   20h
kube-system        coredns-674b8bbfcf-xz8sm                                     1/1     Running   1 (4m23s ago)   20h
kube-system        etcd-kubernetes-1-33-8-containerd-2-2-1                      1/1     Running   2 (4m23s ago)   20h
kube-system        kube-apiserver-kubernetes-1-33-8-containerd-2-2-1            1/1     Running   2 (4m23s ago)   20h
kube-system        kube-controller-manager-kubernetes-1-33-8-containerd-2-2-1   1/1     Running   2 (4m23s ago)   20h
kube-system        kube-proxy-jhz6r                                             1/1     Running   2 (4m23s ago)   20h
kube-system        kube-scheduler-kubernetes-1-33-8-containerd-2-2-1            1/1     Running   2 (4m23s ago)   20h
tigera-operator    tigera-operator-6d69b9b454-pxpf8                             1/1     Running   1 (4m23s ago)   18h
```

### Deploy a pod

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          24s
```

### versions

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl version
Client Version: v1.33.8
Kustomize Version: v5.6.0
Server Version: v1.33.8
root@kubernetes-1-33-8-containerd-2-2-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.2.1 dea7da592f5d1d2b7755e3a161be07f43fad8f75
root@kubernetes-1-33-8-containerd-2-2-1:~# runc --version
runc version 1.3.4
commit: v1.3.4-0-gd6d73eb8
spec: 1.2.1
go: go1.24.10
libseccomp: 2.5.6
root@kubernetes-1-33-8-containerd-2-2-1:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-of-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@kubernetes-1-33-8-containerd-2-2-1:~# uname -a
Linux kubernetes-1-33-8-containerd-2-2-1 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## Build

```shell
make all ENV=kubernetes/v1.33.8/containerd/v2.2.1/calico/debug
```

### For Developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico_debug:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
