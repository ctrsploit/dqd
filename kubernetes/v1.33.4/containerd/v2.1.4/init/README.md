# kubernetes v1.33.4 with containerd v2.1.4

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_init:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_init:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.4_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.4_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.4/containerd/v2.1.4/init
$ ssh dqd-kubernetes-v1.33.4_containerd-v2.1.4_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.4/containerd/v2.1.4/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-4-containerd-2-1-4:~# kubectl get pods -A
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS      AGE
kube-system   coredns-674b8bbfcf-7zp9t                                     0/1     Pending   0             25m
kube-system   coredns-674b8bbfcf-jckkq                                     0/1     Pending   0             25m
kube-system   etcd-kubernetes-1-33-4-containerd-2-1-4                      1/1     Running   1 (10m ago)   26m
kube-system   kube-apiserver-kubernetes-1-33-4-containerd-2-1-4            1/1     Running   1 (10m ago)   26m
kube-system   kube-controller-manager-kubernetes-1-33-4-containerd-2-1-4   1/1     Running   1 (10m ago)   26m
kube-system   kube-proxy-4f9gj                                             1/1     Running   1 (10m ago)   25m
kube-system   kube-scheduler-kubernetes-1-33-4-containerd-2-1-4            1/1     Running   1 (10m ago)   26m
```

### versions

```shell
root@kubernetes-1-33-4-containerd-2-1-4:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-4-containerd-2-1-4:~# kubectl version
Client Version: v1.33.4
Kustomize Version: v5.6.0
Server Version: v1.33.4
root@kubernetes-1-33-4-containerd-2-1-4:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.4 75cb2b7193e4e490e9fbdc236c0e811ccaba3376
root@kubernetes-1-33-4-containerd-2-1-4:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@kubernetes-1-33-4-containerd-2-1-4:~# cat /etc/os-release
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
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@kubernetes-1-33-4-containerd-2-1-4:~# uname -a
Linux kubernetes-1-33-4-containerd-2-1-4 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.33.4/containerd/v2.1.4/init
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_base:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### 1. Use a cache mount to avoid overlayfs-on-overlayfs errors

If you encounter the following error:

```text
[ 2237.540485] overlayfs: filesystem on '/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots/72/fs' not supported as upperdir
```

it typically means an overlayfs is being mounted over another overlayfs. You can solve this issue by using a cache mount within your build process.

Example:

```Dockerfile
# copy image snapshots
RUN --mount=type=cache,id=kubernetes-v1.33.4_containerd-v2.1.4-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# kubeadm init under ext4 fs
RUN --mount=type=cache,id=kubernetes-v1.33.4_containerd-v2.1.4-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    # fix kube-proxy `Failed to load kernel module`
    --mount=type=bind,src=/modules,target=/lib/modules \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
# skip overlayfs whiteout files (c 0,0)
RUN --mount=type=cache,id=kubernetes-v1.33.4_containerd-v2.1.4-snapshots,target=/trick \
    find /trick/snapshots -path '*/work/work/#*' -delete && \
    # use tar to preserve file capabilities
    tar -C /trick -cf - . | tar -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -
```

This approach stores containerd snapshots in a temp cache directory, avoiding nested overlayfs layers and improving build consistency.

> NOTE: mknod is not allowed on overlayfs, even when running as a privileged container.
