# Kubernetes v1.19.1 with containerd v1.4.0, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.19.1_containerd-v1.4.0_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.19.1_containerd-v1.4.0_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.19.1-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.19.1_containerd-v1.4.0_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.19.1-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.19.1/containerd/v1.4.0/calico/default
$ ssh dqd-kubernetes-v1.19.1_containerd-v1.4.0_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.19.1/containerd/v1.4.0/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-19-1-containerd-1-4-0:~# kubectl get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS   AGE
calico-system     calico-kube-controllers-569b4c5cb7-np566                     1/1     Running   1          27m
calico-system     calico-node-p6vcf                                            1/1     Running   1          27m
calico-system     calico-typha-66848bbd87-pqrjk                                1/1     Running   2          27m
kube-system       coredns-f9fd979d6-n7txp                                      1/1     Running   1          11h
kube-system       coredns-f9fd979d6-qtktw                                      1/1     Running   1          11h
kube-system       etcd-kubernetes-1-19-1-containerd-1-4-0                      1/1     Running   2          11h
kube-system       kube-apiserver-kubernetes-1-19-1-containerd-1-4-0            1/1     Running   2          11h
kube-system       kube-controller-manager-kubernetes-1-19-1-containerd-1-4-0   1/1     Running   2          11h
kube-system       kube-proxy-bffkh                                             1/1     Running   2          11h
kube-system       kube-scheduler-kubernetes-1-19-1-containerd-1-4-0            1/1     Running   2          11h
tigera-operator   tigera-operator-655db97ccb-kpx9w                             1/1     Running   2          27m
```

### versions

```shell
root@kubernetes-1-19-1-containerd-1-4-0:~# helm version
version.BuildInfo{Version:"v3.4.0", GitCommit:"7090a89efc8a18f3d8178bf47d2462450349a004", GitTreeState:"clean", GoVersion:"go1.14.10"}
root@kubernetes-1-19-1-containerd-1-4-0:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.1", GitCommit:"206bcadf021e76c27513500ca24182692aabd17e", GitTreeState:"clean", BuildDate:"2020-09-09T11:26:42Z", GoVersion:"go1.15", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.1", GitCommit:"206bcadf021e76c27513500ca24182692aabd17e", GitTreeState:"clean", BuildDate:"2020-09-09T11:18:22Z", GoVersion:"go1.15", Compiler:"gc", Platform:"linux/amd64"}
root@kubernetes-1-19-1-containerd-1-4-0:~# containerd --version
containerd github.com/containerd/containerd v1.4.0 09814d48d50816305a8e6c1a4ae3e2bcc4ba725a
root@kubernetes-1-19-1-containerd-1-4-0:~# runc --version
runc version 1.0.0-rc92
spec: 1.0.2-dev
root@kubernetes-1-19-1-containerd-1-4-0:~# cat /etc/os-release
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
root@kubernetes-1-19-1-containerd-1-4-0:~# uname -a
Linux kubernetes-1-19-1-containerd-1-4-0 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.19.1/containerd/v1.4.0/calico/default
```

GitHub Actions builds the `ctr` image with `CI_DQD_BUILDER=dqd/cgroup-v1-builder` because Kubernetes v1.19.1 kubelet requires cgroup v1.

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.19.1_containerd-v1.4.0_init:ctr_v0.1.2
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup v1

Kubernetes v1.19.1 kubelet only supports cgroup v1. On GitHub-hosted runners, this env declares `CI_DQD_BUILDER=dqd/cgroup-v1-builder`, so CI starts that dqd runtime and runs the `ctr` build there before continuing the VM and DQD image build on the host runner.

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.

### pin buildkit to v0.30.0

`build.sh` passes `--driver-opt image=moby/buildkit:v0.30.0` to `docker buildx create`. The default `moby/buildkit:buildx-stable-1` is a moving tag: it pointed at v0.30.0 when the v1.19.1 init image built successfully, but now points at v0.31.2, whose runc masks `/proc/acpi` with a tmpfs remount (`nr_blocks=1,nr_inodes=1`) that the `dqd/cgroup-v1-builder` VM's kernel 5.4 rejects (`can't mask dir "/proc/acpi": ... invalid argument`), breaking every `RUN`. Pinning to v0.30.0 restores the buildkit that worked for init.
