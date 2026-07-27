# Kubernetes v1.18.2 with containerd v1.3.3, calico

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:v0.1.0 | migrate from docker_archive |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.18.2/containerd/v1.3.3/calico/default
$ ssh dqd-kubernetes-v1.18.2_containerd-v1.3.3_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.18.2/containerd/v1.3.3/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-18-2-containerd-1-3-3:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-18-2-containerd-1-3-3:~# helm version
<!-- VERIFY -->
root@kubernetes-1-18-2-containerd-1-3-3:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-18-2-containerd-1-3-3:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-18-2-containerd-1-3-3:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-18-2-containerd-1-3-3:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-18-2-containerd-1-3-3:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.18.2/containerd/v1.3.3/calico/default
```

GitHub Actions builds the `ctr` image with `CI_DQD_BUILDER=dqd/cgroup-v1-builder` because Kubernetes v1.18.2 kubelet requires cgroup v1.

for developers:

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_init:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup v1

Kubernetes v1.18.2 kubelet only supports cgroup v1. On GitHub-hosted runners, this env declares `CI_DQD_BUILDER=dqd/cgroup-v1-builder`, so CI starts that dqd runtime and runs the `ctr` build there before continuing the VM and DQD image build on the host runner.

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
