# kubernetes v1.26.0 with containerd v1.6.9

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.26.0_containerd-v1.6.9_init:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.26.0_containerd-v1.6.9_init:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.26.0_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.26.0_containerd-v1.6.9_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.26.0_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.26.0/containerd/v1.6.9/init
$ ssh dqd-kubernetes-v1.26.0_containerd-v1.6.9_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.26.0/containerd/v1.6.9/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-26-0-containerd-1-6-9:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-26-0-containerd-1-6-9:~# helm version
<!-- VERIFY -->
root@kubernetes-1-26-0-containerd-1-6-9:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-26-0-containerd-1-6-9:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-26-0-containerd-1-6-9:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-26-0-containerd-1-6-9:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-26-0-containerd-1-6-9:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.26.0/containerd/v1.6.9/init
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.26.0_containerd-v1.6.9_base:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup driver: systemd

Kubernetes v1.26.0 kubelet and containerd both use the `systemd` cgroup driver. `kubeadm.conf` sets `cgroupDriver: systemd` and the Dockerfile writes `/etc/containerd/config.toml` with `SystemdCgroup = true`. The two must agree or kubelet crash-loops and `kubeadm init` never completes. This matches docker_archive v1.26.0 and builds on the GitHub-hosted runner directly (no `cgroup-v1-builder` needed).

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so kubeadm writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
