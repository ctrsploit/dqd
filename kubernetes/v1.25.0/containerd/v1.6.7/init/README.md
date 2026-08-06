# kubernetes v1.25.0 with containerd v1.6.7

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_init:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_init:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.25.0_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.25.0_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.25.0/containerd/v1.6.7/init
$ ssh dqd-kubernetes-v1.25.0_containerd-v1.6.7_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.25.0/containerd/v1.6.7/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-25-0-containerd-1-6-7:~# kubectl get pods -A
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS      AGE
kube-system   coredns-565d847f94-b4858                                     0/1     Pending   0             13m
kube-system   coredns-565d847f94-ck6mn                                     0/1     Pending   0             13m
kube-system   etcd-kubernetes-1-25-0-containerd-1-6-7                      1/1     Running   1 (13m ago)   13m
kube-system   kube-apiserver-kubernetes-1-25-0-containerd-1-6-7            1/1     Running   1 (13m ago)   13m
kube-system   kube-controller-manager-kubernetes-1-25-0-containerd-1-6-7   1/1     Running   1 (13m ago)   13m
kube-system   kube-proxy-crh69                                             1/1     Running   1 (71s ago)   13m
kube-system   kube-scheduler-kubernetes-1-25-0-containerd-1-6-7            1/1     Running   1 (13m ago)   13m
```

### versions

```shell
root@kubernetes-1-25-0-containerd-1-6-7:~# helm version
version.BuildInfo{Version:"v3.10.0", GitCommit:"ce66412a723e4d89555dc67217607c6579ffcb21", GitTreeState:"clean", GoVersion:"go1.18.6"}
root@kubernetes-1-25-0-containerd-1-6-7:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"25", GitVersion:"v1.25.0", GitCommit:"a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2", GitTreeState:"clean", BuildDate:"2022-08-23T17:44:59Z", GoVersion:"go1.19", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.7
Server Version: version.Info{Major:"1", Minor:"25", GitVersion:"v1.25.0", GitCommit:"a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2", GitTreeState:"clean", BuildDate:"2022-08-23T17:38:15Z", GoVersion:"go1.19", Compiler:"gc", Platform:"linux/amd64"}
WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
root@kubernetes-1-25-0-containerd-1-6-7:~# containerd --version
containerd github.com/containerd/containerd v1.6.7 0197261a30bf81f1ee8e6a4dd2dea0ef95d67ccb
root@kubernetes-1-25-0-containerd-1-6-7:~# runc --version
runc version 1.1.3
commit: v1.1.3-0-g6724737f
spec: 1.0.2-dev
go: go1.17.10
libseccomp: 2.5.4
root@kubernetes-1-25-0-containerd-1-6-7:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@kubernetes-1-25-0-containerd-1-6-7:~# uname -a
Linux kubernetes-1-25-0-containerd-1-6-7 5.15.0-187-generic #197-Ubuntu SMP Fri Jul 17 19:17:01 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.25.0/containerd/v1.6.7/init
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_base:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup driver: systemd

Kubernetes v1.25.0 kubelet and containerd both use the `systemd` cgroup driver. `kubeadm.conf` sets `cgroupDriver: systemd` and the Dockerfile writes `/etc/containerd/config.toml` with `SystemdCgroup = true`. The two must agree or kubelet crash-loops and `kubeadm init` never completes. This matches docker_archive v1.25.0 and builds on the GitHub-hosted runner directly (no `cgroup-v1-builder` needed).

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so kubeadm writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
