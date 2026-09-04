# kubernetes v1.36.4 with containerd v2.3.2 (init)

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_init:latest | point to v0.1.2 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_init:v0.1.2 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_init:ctr_v0.1.2 | - |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_init:v0.1.1 | CI failed: service/init.sh + kubeadm.conf still pinned the 2-3-1 hostname |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_init:v0.1.0 | CI failed: base image was published under a wrong name |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.36.4/containerd/v2.3.2/init
$ ssh dqd-kubernetes-v1.36.4_containerd-v2.3.2_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.36.4/containerd/v2.3.2/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS      AGE
kube-system   coredns-589f44dc88-5pzgj                                     0/1     Pending   0             13m
kube-system   coredns-589f44dc88-hbnr4                                     0/1     Pending   0             13m
kube-system   etcd-kubernetes-1-36-4-containerd-2-3-2                      1/1     Running   1 (95s ago)   13m
kube-system   kube-apiserver-kubernetes-1-36-4-containerd-2-3-2            1/1     Running   1 (95s ago)   13m
kube-system   kube-controller-manager-kubernetes-1-36-4-containerd-2-3-2   1/1     Running   1 (95s ago)   13m
kube-system   kube-proxy-rp6nv                                             1/1     Running   1 (95s ago)   13m
kube-system   kube-scheduler-kubernetes-1-36-4-containerd-2-3-2            1/1     Running   1 (95s ago)   13m
```

### versions

```shell
root@kubernetes-1-36-4-containerd-2-3-2:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-36-4-containerd-2-3-2:~# kubectl version
Client Version: v1.36.4
Kustomize Version: v5.8.1
Server Version: v1.36.4
root@kubernetes-1-36-4-containerd-2-3-2:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.3.2 fff62f14765df376e5fc36f5a8f8e795b5670f61
root@kubernetes-1-36-4-containerd-2-3-2:~# runc --version
runc version 1.4.3
commit: v1.4.3-0-gbb14dabeb
spec: 1.3.0
go: go1.25.11
libseccomp: 2.6.0
root@kubernetes-1-36-4-containerd-2-3-2:~# cat /etc/os-release
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
root@kubernetes-1-36-4-containerd-2-3-2:~# uname -a
Linux kubernetes-1-36-4-containerd-2-3-2 6.8.0-139-generic #139-Ubuntu SMP PREEMPT_DYNAMIC Sat Aug  1 03:52:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.36.4/containerd/v2.3.2/init
```


## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_init:ctr_v0.1.2
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug

## Tricks

### 1. Use a cache mount to avoid overlayfs-on-overlayfs errors

If you encounter the following error:

```
[ 2237.540485] overlayfs: filesystem on '/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots/72/fs' not supported as upperdir
```

it typically means an **overlayfs** is being mounted over another **overlayfs**.
You can solve this issue by using a **cache mount** within your build process.

**Example:**

```Dockerfile
# copy image snapshots
RUN --mount=type=cache,id=kubernetes-v1.36.4-containerd-v2.3.2-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# kubeadm init under ext4 fs
RUN --mount=type=cache,id=kubernetes-v1.36.4-containerd-v2.3.2-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    # fix kube-proxy `Failed to load kernel module`
    --mount=type=bind,src=/modules,target=/lib/modules \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
# skip overlayfs whiteout files (c 0,0)
RUN --mount=type=cache,id=kubernetes-v1.36.4-containerd-v2.3.2-snapshots,target=/trick \
    # all these files are safe to delete, list each file path here for more clear
    rm /trick/snapshots/*/work/work/#* && \
    # use tar to preserve file capabilities
    tar --xattrs --xattrs-include='*' -C /trick -cf - . | tar --xattrs --xattrs-include='*' -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -
```

This approach stores containerd snapshots in a temp cache directory, avoiding nested overlayfs layers and improving build consistency.

> NOTE: mknod is not allowed on overlayfs, even when running as a privileged container.
