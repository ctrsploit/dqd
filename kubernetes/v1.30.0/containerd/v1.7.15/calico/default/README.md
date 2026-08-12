# Kubernetes v1.30.0 with containerd v1.7.15, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.30.0_containerd-v1.7.15_calico:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.30.0_containerd-v1.7.15_calico:v0.1.0 | migrate from docker_archive (FROM init ctr_v0.1.0) |
| dqd | ssst0n3/docker_archive:kubernetes-v1.30.0-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.30.0_containerd-v1.7.15_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.30.0-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.30.0/containerd/v1.7.15/calico/default
$ ssh dqd-kubernetes-v1.30.0_containerd-v1.7.15_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.30.0/containerd/v1.7.15/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-30-0-containerd-1-7-15:~# kubectl get pods -A
NAMESPACE          NAME                                                          READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-5bf894848f-nrvs4                             1/1     Running   1 (3m48s ago)   3h35m
calico-apiserver   calico-apiserver-5bf894848f-tmxpb                             1/1     Running   1 (3m48s ago)   3h34m
calico-system      calico-kube-controllers-7878f888b4-l6vp7                      1/1     Running   1 (3m48s ago)   3h35m
calico-system      calico-node-lzg8k                                             1/1     Running   1 (3m48s ago)   3h35m
calico-system      calico-typha-769b988c46-gj9rp                                 1/1     Running   1 (3m48s ago)   3h35m
calico-system      csi-node-driver-chrdm                                         2/2     Running   2 (3m48s ago)   3h35m
kube-system        coredns-7db6d8ff4d-5dwc8                                      1/1     Running   1 (3m48s ago)   5h25m
kube-system        coredns-7db6d8ff4d-5x8rf                                      1/1     Running   1 (3m48s ago)   5h25m
kube-system        etcd-kubernetes-1-30-0-containerd-1-7-15                      1/1     Running   2 (3m48s ago)   5h25m
kube-system        kube-apiserver-kubernetes-1-30-0-containerd-1-7-15            1/1     Running   2 (3m48s ago)   5h25m
kube-system        kube-controller-manager-kubernetes-1-30-0-containerd-1-7-15   1/1     Running   2 (3m48s ago)   5h25m
kube-system        kube-proxy-pk8ng                                              1/1     Running   2 (3m48s ago)   5h25m
kube-system        kube-scheduler-kubernetes-1-30-0-containerd-1-7-15            1/1     Running   2 (3m48s ago)   5h25m
tigera-operator    tigera-operator-696858f46-rk84h                               1/1     Running   1 (3m48s ago)   3h35m
```

### versions

```shell
root@kubernetes-1-30-0-containerd-1-7-15:~# helm version
version.BuildInfo{Version:"v3.15.0-rc.2", GitCommit:"c4e37b39dbb341cb3f716220df9f9d306d123a58", GitTreeState:"clean", GoVersion:"go1.22.3"}
root@kubernetes-1-30-0-containerd-1-7-15:~# kubectl version
Client Version: v1.30.0
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.30.0
root@kubernetes-1-30-0-containerd-1-7-15:~# containerd --version
containerd github.com/containerd/containerd v1.7.15 926c9586fe4a6236699318391cd44976a98e31f1
root@kubernetes-1-30-0-containerd-1-7-15:~# runc --version
runc version 1.1.12
commit: v1.1.12-0-g51d5e946
spec: 1.0.2-dev
go: go1.20.13
libseccomp: 2.5.4
root@kubernetes-1-30-0-containerd-1-7-15:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@kubernetes-1-30-0-containerd-1-7-15:~# uname -a
Linux kubernetes-1-30-0-containerd-1-7-15 5.15.0-187-generic #197-Ubuntu SMP Fri Jul 17 19:17:01 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.30.0/containerd/v1.7.15/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.30.0_containerd-v1.7.15_init:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
