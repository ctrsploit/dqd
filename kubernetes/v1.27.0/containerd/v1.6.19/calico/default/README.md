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
NAMESPACE          NAME                                                          READY   STATUS    RESTARTS      AGE
calico-apiserver   calico-apiserver-5cf54ff489-lrkqk                             1/1     Running   1 (98s ago)   22m
calico-apiserver   calico-apiserver-5cf54ff489-vk9k2                             1/1     Running   1 (98s ago)   22m
calico-system      calico-kube-controllers-bf9867dc7-dgjdt                       1/1     Running   1 (98s ago)   23m
calico-system      calico-node-hqpc4                                             1/1     Running   1 (98s ago)   23m
calico-system      calico-typha-65d8f58685-kzf2z                                 1/1     Running   2 (58s ago)   23m
calico-system      csi-node-driver-7t4tq                                         2/2     Running   2 (98s ago)   23m
kube-system        coredns-5d78c9869d-nn2j5                                      1/1     Running   1 (98s ago)   127m
kube-system        coredns-5d78c9869d-x5dlk                                      1/1     Running   1 (99s ago)   127m
kube-system        etcd-kubernetes-1-27-0-containerd-1-6-19                      1/1     Running   2 (98s ago)   127m
kube-system        kube-apiserver-kubernetes-1-27-0-containerd-1-6-19            1/1     Running   2 (98s ago)   127m
kube-system        kube-controller-manager-kubernetes-1-27-0-containerd-1-6-19   1/1     Running   2 (98s ago)   127m
kube-system        kube-proxy-452zm                                              1/1     Running   2 (98s ago)   127m
kube-system        kube-scheduler-kubernetes-1-27-0-containerd-1-6-19            1/1     Running   2 (98s ago)   127m
tigera-operator    tigera-operator-7b4b4fcf5d-56nvw                              1/1     Running   2 (52s ago)   23m
```

### versions

```shell
root@kubernetes-1-27-0-containerd-1-6-19:~# helm version
version.BuildInfo{Version:"v3.12.0", GitCommit:"c9f554d75773799f72ceef38c51210f1842a1dea", GitTreeState:"clean", GoVersion:"go1.20.3"}
root@kubernetes-1-27-0-containerd-1-6-19:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.0", GitCommit:"1b4df30b3cdfeaba6024e81e559a6cd09a089d65", GitTreeState:"clean", BuildDate:"2023-04-11T17:10:18Z", GoVersion:"go1.20.3", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v5.0.1
Server Version: version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.0", GitCommit:"1b4df30b3cdfeaba6024e81e559a6cd09a089d65", GitTreeState:"clean", BuildDate:"2023-04-11T17:04:24Z", GoVersion:"go1.20.3", Compiler:"gc", Platform:"linux/amd64"}
WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version information.
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
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-privacy-policy"
UBUNTU_CODENAME=jammy
root@kubernetes-1-27-0-containerd-1-6-19:~# uname -a
Linux kubernetes-1-27-0-containerd-1-6-19 5.15.0-187-generic #197-Ubuntu SMP Fri Jul 17 19:17:01 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
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
