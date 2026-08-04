# kubernetes v1.23.0 with containerd v1.5.2

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.23.0_containerd-v1.5.2_init:latest | -> v0.1.1 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.23.0_containerd-v1.5.2_init:v0.1.1 | fix: chmod +x build.sh/init.sh/hosts.sh/ssh so CI can run ./build.sh |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.23.0_containerd-v1.5.2_init:v0.1.0 | build.sh not executable; CI fails with `./build.sh: Permission denied` (Error 126) |
| dqd | ssst0n3/docker_archive:kubernetes-v1.23.0_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.23.0_containerd-v1.5.2_init:ctr_v0.1.1 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.23.0_containerd-v1.5.2_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.23.0_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.23.0/containerd/v1.5.2/init
$ ssh dqd-kubernetes-v1.23.0_containerd-v1.5.2_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.23.0/containerd/v1.5.2/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-23-0-containerd-1-5-2:~# kubectl get pods -A
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS      AGE
kube-system   coredns-64897985d-74rjk                                      0/1     Pending   0             57m
kube-system   coredns-64897985d-m88cp                                      0/1     Pending   0             57m
kube-system   etcd-kubernetes-1-23-0-containerd-1-5-2                      1/1     Running   1 (10m ago)   57m
kube-system   kube-apiserver-kubernetes-1-23-0-containerd-1-5-2            1/1     Running   1 (10m ago)   57m
kube-system   kube-controller-manager-kubernetes-1-23-0-containerd-1-5-2   1/1     Running   1 (10m ago)   57m
kube-system   kube-proxy-hkwtb                                             1/1     Running   1 (10m ago)   57m
kube-system   kube-scheduler-kubernetes-1-23-0-containerd-1-5-2            1/1     Running   1 (10m ago)   57m
```

### versions

```shell
root@kubernetes-1-23-0-containerd-1-5-2:~# helm version
version.BuildInfo{Version:"v3.8.0", GitCommit:"d14138609b01886f544b2025f5000351c9eb092e", GitTreeState:"clean", GoVersion:"go1.17.5"}
root@kubernetes-1-23-0-containerd-1-5-2:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.0", GitCommit:"ab69524f795c42094a6630298ff53f3c3ebab7f4", GitTreeState:"clean", BuildDate:"2021-12-07T18:16:20Z", GoVersion:"go1.17.3", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.0", GitCommit:"ab69524f795c42094a6630298ff53f3c3ebab7f4", GitTreeState:"clean", BuildDate:"2021-12-07T18:09:57Z", GoVersion:"go1.17.3", Compiler:"gc", Platform:"linux/amd64"}
root@kubernetes-1-23-0-containerd-1-5-2:~# containerd --version
containerd github.com/containerd/containerd v1.5.2 36cc874494a56a253cd181a1a685b44b58a2e34a
root@kubernetes-1-23-0-containerd-1-5-2:~# runc --version
runc version 1.0.0-rc95
spec: 1.0.2-dev
go: go1.14.15
libseccomp: 2.5.1
root@kubernetes-1-23-0-containerd-1-5-2:~# cat /etc/os-release
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
root@kubernetes-1-23-0-containerd-1-5-2:~# uname -a
Linux kubernetes-1-23-0-containerd-1-5-2 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.23.0/containerd/v1.5.2/init
```

GitHub Actions builds the `ctr` image with `CI_DQD_BUILDER=dqd/cgroup-v1-builder` because Kubernetes v1.23.0 kubelet requires cgroup v1 during `kubeadm init`.

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.23.0_containerd-v1.5.2_base:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup v1

Kubernetes v1.23.0 kubelet only supports cgroup v1. On GitHub-hosted runners, this env declares `CI_DQD_BUILDER=dqd/cgroup-v1-builder`, so CI starts that dqd runtime and runs the `ctr` build there before continuing the VM and DQD image build on the host runner.

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so kubeadm writes under an ext4-backed cache instead of overlayfs-on-overlayfs.

### pin buildkit to v0.30.0

`build.sh` pins `BUILDX_IMAGE="moby/buildkit:v0.30.0"`. BuildKit v0.31 moved to runc v1.3, which masks `/proc/acpi` and is rejected by the cgroup-v1-builder VM's kernel 5.4; v0.30.0 keeps the older runc that allows `/proc/acpi`.
