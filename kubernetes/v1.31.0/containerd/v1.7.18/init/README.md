# kubernetes v1.31.0 with containerd v1.7.18

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.31.0_containerd-v1.7.18_init:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.31.0_containerd-v1.7.18_init:v0.1.0 | migrate from docker_archive (preserve xattrs in snapshot-restore tar) |
| dqd | ssst0n3/docker_archive:kubernetes-v1.31.0_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.31.0_containerd-v1.7.18_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.31.0_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.31.0/containerd/v1.7.18/init
$ ssh dqd-kubernetes-v1.31.0_containerd-v1.7.18_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.31.0/containerd/v1.7.18/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-31-0-containerd-1-7-18:~# kubectl get pods -A
NAMESPACE     NAME                                                          READY   STATUS    RESTARTS      AGE
kube-system   coredns-6f6b679f8f-7k5ns                                      0/1     Pending   0             56m
kube-system   coredns-6f6b679f8f-lcj67                                      0/1     Pending   0             56m
kube-system   etcd-kubernetes-1-31-0-containerd-1-7-18                      1/1     Running   1 (77s ago)   56m
kube-system   kube-apiserver-kubernetes-1-31-0-containerd-1-7-18            1/1     Running   1 (77s ago)   56m
kube-system   kube-controller-manager-kubernetes-1-31-0-containerd-1-7-18   1/1     Running   1 (77s ago)   56m
kube-system   kube-proxy-xg8cm                                              1/1     Running   1 (77s ago)   56m
kube-system   kube-scheduler-kubernetes-1-31-0-containerd-1-7-18            1/1     Running   1 (77s ago)   56m
```

### versions

```shell
root@kubernetes-1-31-0-containerd-1-7-18:~# helm version
version.BuildInfo{Version:"v3.16.0", GitCommit:"0d439e1a09683f21a0ab9401eb661401f185b00b", GitTreeState:"clean", GoVersion:"go1.22.6"}
root@kubernetes-1-31-0-containerd-1-7-18:~# kubectl version
Client Version: v1.31.0
Kustomize Version: v5.4.2
Server Version: v1.31.0
root@kubernetes-1-31-0-containerd-1-7-18:~# containerd --version
containerd github.com/containerd/containerd v1.7.18 ae71819c4f5e67bb4d5ae76a6b735f29cc25774e
root@kubernetes-1-31-0-containerd-1-7-18:~# runc --version
runc version 1.1.12
commit: v1.1.12-0-g51d5e946
spec: 1.0.2-dev
go: go1.20.13
libseccomp: 2.5.4
root@kubernetes-1-31-0-containerd-1-7-18:~# cat /etc/os-release
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
root@kubernetes-1-31-0-containerd-1-7-18:~# uname -a
Linux kubernetes-1-31-0-containerd-1-7-18 5.15.0-187-generic #197-Ubuntu SMP Fri Jul 17 19:17:01 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.31.0/containerd/v1.7.18/init
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.31.0_containerd-v1.7.18_base:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup driver: systemd

Kubernetes v1.31.0 kubelet and containerd both use the `systemd` cgroup driver. `kubeadm.conf` sets `cgroupDriver: systemd` and the Dockerfile writes `/etc/containerd/config.toml` with `SystemdCgroup = true`. The two must agree or kubelet crash-loops and `kubeadm init` never completes. This matches docker_archive v1.31.0 and builds on the GitHub-hosted runner directly (no `cgroup-v1-builder` needed).

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so kubeadm writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
