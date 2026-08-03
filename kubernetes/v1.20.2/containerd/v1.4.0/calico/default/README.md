# Kubernetes v1.20.2 with containerd v1.4.0, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.20.2_containerd-v1.4.0_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.20.2_containerd-v1.4.0_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.20.2-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.20.2_containerd-v1.4.0_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.20.2-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.20.2/containerd/v1.4.0/calico/default
$ ssh dqd-kubernetes-v1.20.2_containerd-v1.4.0_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.20.2/containerd/v1.4.0/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-20-2-containerd-1-4-0:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-20-2-containerd-1-4-0:~# helm version
<!-- VERIFY -->
root@kubernetes-1-20-2-containerd-1-4-0:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-20-2-containerd-1-4-0:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-20-2-containerd-1-4-0:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-20-2-containerd-1-4-0:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-20-2-containerd-1-4-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.20.2/containerd/v1.4.0/calico/default
```

GitHub Actions builds the `ctr` image with `CI_DQD_BUILDER=dqd/cgroup-v1-builder` because Kubernetes v1.20.2 kubelet requires cgroup v1.

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.20.2_containerd-v1.4.0_init:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup v1

Kubernetes v1.20.2 kubelet only supports cgroup v1. On GitHub-hosted runners, this env declares `CI_DQD_BUILDER=dqd/cgroup-v1-builder`, so CI starts that dqd runtime and runs the `ctr` build there before continuing the VM and DQD image build on the host runner.

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.

### pin buildkit to v0.30.0

`build.sh` pins `BUILDX_IMAGE="moby/buildkit:v0.30.0"`. BuildKit v0.31 moved to runc v1.3, which masks `/proc/acpi` and is rejected by the cgroup-v1-builder VM's kernel 5.4; v0.30.0 keeps the older runc that allows `/proc/acpi`.
