# kubernetes v1.27.0 with containerd v1.6.19

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_init:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_init:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.27.0_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_init:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.27.0_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.27.0/containerd/v1.6.19/init
$ ssh dqd-kubernetes-v1.27.0_containerd-v1.6.19_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.27.0/containerd/v1.6.19/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-27-0-containerd-1-6-19:~# kubectl get pods -A
NAMESPACE     NAME                                                          READY   STATUS    RESTARTS      AGE
kube-system   coredns-5d78c9869d-nn2j5                                      0/1     Pending   0             26m
kube-system   coredns-5d78c9869d-x5dlk                                      0/1     Pending   0             26m
kube-system   etcd-kubernetes-1-27-0-containerd-1-6-19                      1/1     Running   1 (12m ago)   26m
kube-system   kube-apiserver-kubernetes-1-27-0-containerd-1-6-19            1/1     Running   1 (12m ago)   26m
kube-system   kube-controller-manager-kubernetes-1-27-0-containerd-1-6-19   1/1     Running   1 (12m ago)   26m
kube-system   kube-proxy-452zm                                              1/1     Running   1 (12m ago)   25m
kube-system   kube-scheduler-kubernetes-1-27-0-containerd-1-6-19            1/1     Running   1 (12m ago)   26m
```

### versions

```shell
root@kubernetes-1-27-0-containerd-1-6-19:~# helm version
version.BuildInfo{Version:"v3.12.0", GitCommit:"c9f554d75773799f72ceef38c51210f1842a1dea", GitTreeState:"clean", GoVersion:"go1.20.3"}
root@kubernetes-1-27-0-containerd-1-6-19:~# kubectl version
WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
Client Version: version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.0", GitCommit:"1b4df30b3cdfeaba6024e81e559a6cd09a089d65", GitTreeState:"clean", BuildDate:"2023-04-11T17:10:18Z", GoVersion:"go1.20.3", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v5.0.1
Server Version: version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.0", GitCommit:"1b4df30b3cdfeaba6024e81e559a6cd09a089d65", GitTreeState:"clean", BuildDate:"2023-04-11T17:04:24Z", GoVersion:"go1.20.3", Compiler:"gc", Platform:"linux/amd64"}
root@kubernetes-1-27-0-containerd-1-6-19:~# containerd --version
containerd github.com/containerd/containerd v1.6.19 1e1ea6e986c6c86565bc33d52e34b81b3e2bc71f
root@kubernetes-1-27-0-containerd-1-6-19:~# runc --version
runc version 1.1.4
commit: v1.1.4-0-g5fd4c4d1
spec: 1.0.2-dev
go: go1.17.10
libseccomp: 2.5.4
root@kubernetes-1-27-0-containerd-1-6-19:~# cat /etc/os-release
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
root@kubernetes-1-27-0-containerd-1-6-19:~# uname -a
Linux kubernetes-1-27-0-containerd-1-6-19 5.15.0-187-generic #197-Ubuntu SMP Fri Jul 17 19:17:01 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.27.0/containerd/v1.6.19/init
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_base:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cgroup driver: systemd

Kubernetes v1.27.0 kubelet and containerd both use the `systemd` cgroup driver. `kubeadm.conf` sets `cgroupDriver: systemd` and the Dockerfile writes `/etc/containerd/config.toml` with `SystemdCgroup = true`. The two must agree or kubelet crash-loops and `kubeadm init` never completes. This matches docker_archive v1.27.0 and builds on the GitHub-hosted runner directly (no `cgroup-v1-builder` needed).

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so kubeadm writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
