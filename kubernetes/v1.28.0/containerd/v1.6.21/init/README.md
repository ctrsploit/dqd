# kubernetes v1.28.0 with containerd v1.6.21

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.28.0_containerd-v1.6.21_init:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.28.0_containerd-v1.6.21_init:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.28.0_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.28.0_containerd-v1.6.21_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.28.0_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.28.0/containerd/v1.6.21/init
$ ssh dqd-kubernetes-v1.28.0_containerd-v1.6.21_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.28.0/containerd/v1.6.21/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-28-0-containerd-1-6-21:~# kubectl get pods -A
NAMESPACE     NAME                                                          READY   STATUS    RESTARTS      AGE
kube-system   coredns-5dd5756b68-td4dk                                      0/1     Pending   0             42m
kube-system   coredns-5dd5756b68-wdfds                                      0/1     Pending   0             42m
kube-system   etcd-kubernetes-1-28-0-containerd-1-6-21                      1/1     Running   1 (89s ago)   43m
kube-system   kube-apiserver-kubernetes-1-28-0-containerd-1-6-21            1/1     Running   1 (42m ago)   43m
kube-system   kube-controller-manager-kubernetes-1-28-0-containerd-1-6-21   1/1     Running   1 (42m ago)   43m
kube-system   kube-proxy-wd9bs                                              1/1     Running   1 (89s ago)   42m
kube-system   kube-scheduler-kubernetes-1-28-0-containerd-1-6-21            1/1     Running   1 (42m ago)   43m
```

### versions

```shell
root@kubernetes-1-28-0-containerd-1-6-21:~# helm version
version.BuildInfo{Version:"v3.13.0", GitCommit:"825e86f6a7a38cef1112bfa606e4127a706749b1", GitTreeState:"clean", GoVersion:"go1.20.8"}
root@kubernetes-1-28-0-containerd-1-6-21:~# kubectl version
Client Version: v1.28.0
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.28.0
root@kubernetes-1-28-0-containerd-1-6-21:~# containerd --version
containerd github.com/containerd/containerd v1.6.21 3dce8eb055cbb6872793272b4f20ed16117344f8
root@kubernetes-1-28-0-containerd-1-6-21:~# runc --version
runc version 1.1.7
commit: v1.1.7-0-g860f061b
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
root@kubernetes-1-28-0-containerd-1-6-21:~# cat /etc/os-release
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
root@kubernetes-1-28-0-containerd-1-6-21:~# uname -a
Linux kubernetes-1-28-0-containerd-1-6-21 5.15.0-187-generic #197-Ubuntu SMP Fri Jul 17 19:17:01 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.28.0/containerd/v1.6.21/init
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.28.0_containerd-v1.6.21_base:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup driver: systemd

Kubernetes v1.28.0 kubelet and containerd both use the `systemd` cgroup driver. `kubeadm.conf` sets `cgroupDriver: systemd` and the Dockerfile writes `/etc/containerd/config.toml` with `SystemdCgroup = true`. The two must agree or kubelet crash-loops and `kubeadm init` never completes. This matches docker_archive v1.28.0 and builds on the GitHub-hosted runner directly (no `cgroup-v1-builder` needed).

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so kubeadm writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
