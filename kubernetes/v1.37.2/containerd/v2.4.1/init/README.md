# kubernetes v1.37.2 with containerd v2.4.1 (init)

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.37.2_containerd-v2.4.1_init:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.37.2_containerd-v2.4.1_init:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.37.2_containerd-v2.4.1_init:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.37.2/containerd/v2.4.1/init
$ ssh dqd-kubernetes-v1.37.2_containerd-v2.4.1_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.37.2/containerd/v2.4.1/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS      AGE
kube-system   coredns-559f6c778d-jr64w                                     0/1     Pending   0             16h
kube-system   coredns-559f6c778d-xcvk5                                     0/1     Pending   0             16h
kube-system   etcd-kubernetes-1-37-2-containerd-2-4-1                      1/1     Running   1 (83s ago)   16h
kube-system   kube-apiserver-kubernetes-1-37-2-containerd-2-4-1            1/1     Running   1 (83s ago)   16h
kube-system   kube-controller-manager-kubernetes-1-37-2-containerd-2-4-1   1/1     Running   1 (83s ago)   16h
kube-system   kube-proxy-vkhmg                                             1/1     Running   1 (83s ago)   16h
kube-system   kube-scheduler-kubernetes-1-37-2-containerd-2-4-1            1/1     Running   1 (83s ago)   16h
```

### versions

```shell
root@kubernetes-1-37-2-containerd-2-4-1:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-37-2-containerd-2-4-1:~# kubectl version
Client Version: v1.37.2
Kustomize Version: v5.8.1
Server Version: v1.37.2
root@kubernetes-1-37-2-containerd-2-4-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.4.1 f2551031d7276a770f65f98c9b52e57e7dad07e8
root@kubernetes-1-37-2-containerd-2-4-1:~# runc --version
runc version 1.5.1
commit: v1.5.1-0-g8f2685a47
spec: 1.3.0
go: go1.25.12
libseccomp: 2.6.0
libpathrs: 0.2.5
root@kubernetes-1-37-2-containerd-2-4-1:~# cat /etc/os-release
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
root@kubernetes-1-37-2-containerd-2-4-1:~# uname -a
Linux kubernetes-1-37-2-containerd-2-4-1 6.8.0-149-generic #149-Ubuntu SMP PREEMPT_DYNAMIC Fri Oct 23 13:21:10 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.37.2/containerd/v2.4.1/init
```


## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.37.2_containerd-v2.4.1_init:ctr_v0.1.0
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
RUN --mount=type=cache,id=kubernetes-v1.37.2-containerd-v2.4.1-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# kubeadm init under ext4 fs
RUN --mount=type=cache,id=kubernetes-v1.37.2-containerd-v2.4.1-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    # fix kube-proxy `Failed to load kernel module`
    --mount=type=bind,src=/modules,target=/lib/modules \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
# skip overlayfs whiteout files (c 0,0)
RUN --mount=type=cache,id=kubernetes-v1.37.2-containerd-v2.4.1-snapshots,target=/trick \
    # all these files are safe to delete, list each file path here for more clear
    rm /trick/snapshots/*/work/work/#* && \
    # use tar to preserve file capabilities
    tar --xattrs --xattrs-include='*' -C /trick -cf - . | tar --xattrs --xattrs-include='*' -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -
```

This approach stores containerd snapshots in a temp cache directory, avoiding nested overlayfs layers and improving build consistency.

> NOTE: mknod is not allowed on overlayfs, even when running as a privileged container.
