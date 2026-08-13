# kubernetes v1.33.1 with containerd v2.1.0

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_init:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_init:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.1_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.1_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.1/containerd/v2.1.0/init
$ ssh dqd-kubernetes-v1.33.1_containerd-v2.1.0_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.1/containerd/v2.1.0/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl get pods -A
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS      AGE
kube-system   coredns-674b8bbfcf-pclnm                                     0/1     Pending   0             11h
kube-system   coredns-674b8bbfcf-w2kxj                                     0/1     Pending   0             11h
kube-system   etcd-kubernetes-1-33-1-containerd-2-1-0                      1/1     Running   1 (17m ago)   11h
kube-system   kube-apiserver-kubernetes-1-33-1-containerd-2-1-0            1/1     Running   1 (17m ago)   11h
kube-system   kube-controller-manager-kubernetes-1-33-1-containerd-2-1-0   1/1     Running   1 (17m ago)   11h
kube-system   kube-proxy-vksb8                                             1/1     Running   1 (17m ago)   11h
kube-system   kube-scheduler-kubernetes-1-33-1-containerd-2-1-0            1/1     Running   1 (17m ago)   11h
```

### versions

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# helm version
version.BuildInfo{Version:"v3.18.3", GitCommit:"6838ebcf265a3842d1433956e8a622e3290cf324", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl version
Client Version: v1.33.1
Kustomize Version: v5.6.0
Server Version: v1.33.1
root@kubernetes-1-33-1-containerd-2-1-0:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.0 061792f0ecf3684fb30a3a0eb006799b8c6638a7
root@kubernetes-1-33-1-containerd-2-1-0:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@kubernetes-1-33-1-containerd-2-1-0:~# cat /etc/os-release
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
root@kubernetes-1-33-1-containerd-2-1-0:~# uname -a
Linux kubernetes-1-33-1-containerd-2-1-0 6.8.0-137-generic #137-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 17 20:28:23 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.33.1/containerd/v2.1.0/init
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_base:ctr_v0.1.0
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
RUN --mount=type=cache,id=kubernetes-v1.33.1_containerd-v2.1.0-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# kubeadm init under ext4 fs
RUN --mount=type=cache,id=kubernetes-v1.33.1_containerd-v2.1.0-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    # fix kube-proxy `Failed to load kernel module`
    --mount=type=bind,src=/modules,target=/lib/modules \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
# skip overlayfs whiteout files (c 0,0)
RUN --mount=type=cache,id=kubernetes-v1.33.1_containerd-v2.1.0-snapshots,target=/trick \
    find /trick/snapshots -path '*/work/work/#*' -delete && \
    # use tar to preserve file capabilities
    tar --xattrs --xattrs-include='*' -C /trick -cf - . | tar --xattrs --xattrs-include='*' -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -
```

This approach stores containerd snapshots in a temp cache directory, avoiding nested overlayfs layers and improving build consistency.

> NOTE: mknod is not allowed on overlayfs, even when running as a privileged container.
