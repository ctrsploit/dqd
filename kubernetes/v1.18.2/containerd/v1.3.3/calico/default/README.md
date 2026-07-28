# Kubernetes v1.18.2 with containerd v1.3.3, calico

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:latest | points to `v0.1.4` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:v0.1.4 | make build.sh executable (was 100644) + build on 30G cgroup-v1-builder |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:v0.1.3 | 30G builder; CI surfaced build.sh Permission denied (Makefile fix unmasked it) |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:v0.1.2 | pin buildkit to v0.30.0 (fixes runc /proc/acpi) |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:v0.1.1 | drop unneeded buildx --bootstrap (CI still failed) |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:v0.1.0 | migrate from docker_archive (CI failed) |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:ctr_v0.1.4 | - |

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
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS   AGE
calico-system     calico-kube-controllers-57f767d97b-tcf62                     1/1     Running   1          43m
calico-system     calico-node-sz4zf                                            1/1     Running   1          43m
calico-system     calico-typha-9cc6b5ffc-7b8gc                                 1/1     Running   1          43m
kube-system       coredns-66bff467f8-ntd5z                                     1/1     Running   1          54d
kube-system       coredns-66bff467f8-rzprn                                     1/1     Running   1          54d
kube-system       etcd-kubernetes-1-18-2-containerd-1-3-3                      1/1     Running   2          54d
kube-system       kube-apiserver-kubernetes-1-18-2-containerd-1-3-3            1/1     Running   2          54d
kube-system       kube-controller-manager-kubernetes-1-18-2-containerd-1-3-3   1/1     Running   2          54d
kube-system       kube-proxy-25jcz                                             1/1     Running   2          54d
kube-system       kube-scheduler-kubernetes-1-18-2-containerd-1-3-3            1/1     Running   2          54d
tigera-operator   tigera-operator-6ddb54fbf5-pz878                             1/1     Running   2          44m
```

### versions

```shell
root@kubernetes-1-18-2-containerd-1-3-3:~# helm version
version.BuildInfo{Version:"v3.2.4", GitCommit:"0ad800ef43d3b826f31a5ad8dfbb4fe05d143688", GitTreeState:"clean", GoVersion:"go1.13.12"}
root@kubernetes-1-18-2-containerd-1-3-3:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:56:40Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:48:36Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
root@kubernetes-1-18-2-containerd-1-3-3:~# containerd --version
containerd github.com/containerd/containerd v1.3.3 d76c121f76a5fc8a462dc64594aea72fe18e1178
root@kubernetes-1-18-2-containerd-1-3-3:~# runc --version
runc version 1.0.0-rc10
spec: 1.0.1-dev
root@kubernetes-1-18-2-containerd-1-3-3:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.6 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.6 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
root@kubernetes-1-18-2-containerd-1-3-3:~# uname -a
Linux kubernetes-1-18-2-containerd-1-3-3 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
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

### pin buildkit to v0.30.0

`build.sh` passes `--driver-opt image=moby/buildkit:v0.30.0` to `docker buildx create`. The default `moby/buildkit:buildx-stable-1` is a moving tag: it pointed at v0.30.0 when the v1.18.2 init image built successfully on 2026-06-04, but now points at v0.31.2, whose runc masks `/proc/acpi` with a tmpfs remount (`nr_blocks=1,nr_inodes=1`) that the `dqd/cgroup-v1-builder` VM's kernel 5.4 rejects (`can't mask dir "/proc/acpi": ... invalid argument`), breaking every `RUN`. Pinning to v0.30.0 restores the buildkit that worked for init.
