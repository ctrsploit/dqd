# kubernetes v1.33.3 with containerd v2.1.2

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.2_init:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.2_init:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.3_containerd-v2.1.2_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.2_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.3_containerd-v2.1.2_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.3/containerd/v2.1.2/init
$ ssh dqd-kubernetes-v1.33.3_containerd-v2.1.2_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.3/containerd/v2.1.2/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-3-containerd-2-1-2:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-33-3-containerd-2-1-2:~# helm version
<!-- VERIFY -->
root@kubernetes-1-33-3-containerd-2-1-2:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-33-3-containerd-2-1-2:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-33-3-containerd-2-1-2:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-33-3-containerd-2-1-2:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-33-3-containerd-2-1-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.33.3/containerd/v2.1.2/init
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.2_base:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
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
RUN --mount=type=cache,id=kubernetes-v1.33.3_containerd-v2.1.2-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# kubeadm init under ext4 fs
RUN --mount=type=cache,id=kubernetes-v1.33.3_containerd-v2.1.2-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    # fix kube-proxy `Failed to load kernel module`
    --mount=type=bind,src=/modules,target=/lib/modules \
    --security=insecure \
    ["/sbin/init", "--log-target=kmsg"]
# skip overlayfs whiteout files (c 0,0)
RUN --mount=type=cache,id=kubernetes-v1.33.3_containerd-v2.1.2-snapshots,target=/trick \
    find /trick/snapshots -path '*/work/work/#*' -delete && \
    # use tar to preserve file capabilities
    tar -C /trick -cf - . | tar -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -
```

This approach stores containerd snapshots in a temp cache directory, avoiding nested overlayfs layers and improving build consistency.

> NOTE: mknod is not allowed on overlayfs, even when running as a privileged container.
