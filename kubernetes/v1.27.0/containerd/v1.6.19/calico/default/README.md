# Kubernetes v1.27.0 with containerd v1.6.19, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_calico:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.27.0-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.27.0-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.27.0/containerd/v1.6.19/calico/default
$ ssh dqd-kubernetes-v1.27.0_containerd-v1.6.19_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.27.0/containerd/v1.6.19/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-27-0-containerd-1-6-19:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-27-0-containerd-1-6-19:~# helm version
<!-- VERIFY -->
root@kubernetes-1-27-0-containerd-1-6-19:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-27-0-containerd-1-6-19:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-27-0-containerd-1-6-19:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-27-0-containerd-1-6-19:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-27-0-containerd-1-6-19:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.27.0/containerd/v1.6.19/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_init:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
