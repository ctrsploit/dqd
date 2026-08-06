# Kubernetes v1.26.0 with containerd v1.6.9, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.26.0_containerd-v1.6.9_calico:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.26.0_containerd-v1.6.9_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.26.0-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.26.0_containerd-v1.6.9_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.26.0-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.26.0/containerd/v1.6.9/calico/default
$ ssh dqd-kubernetes-v1.26.0_containerd-v1.6.9_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.26.0/containerd/v1.6.9/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-26-0-containerd-1-6-9:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-6c67b59dd8-7x8g4                            1/1     Running   1 (6m56s ago)   27m
calico-apiserver   calico-apiserver-6c67b59dd8-nkjvp                            1/1     Running   1 (6m56s ago)   27m
calico-system      calico-kube-controllers-84dd694985-jg56t                     1/1     Running   1 (6m56s ago)   27m
calico-system      calico-node-jg7qd                                            1/1     Running   1 (6m56s ago)   27m
calico-system      calico-typha-5dc7d8dfb-5hthx                                 1/1     Running   1 (6m56s ago)   27m
calico-system      csi-node-driver-dx2bf                                        2/2     Running   2 (6m56s ago)   27m
kube-system        coredns-787d4945fb-5tt9z                                     1/1     Running   1 (6m56s ago)   101m
kube-system        coredns-787d4945fb-bcp87                                     1/1     Running   1 (6m56s ago)   101m
kube-system        etcd-kubernetes-1-26-0-containerd-1-6-9                      1/1     Running   2 (6m56s ago)   102m
kube-system        kube-apiserver-kubernetes-1-26-0-containerd-1-6-9            1/1     Running   2 (6m56s ago)   102m
kube-system        kube-controller-manager-kubernetes-1-26-0-containerd-1-6-9   1/1     Running   2 (6m56s ago)   102m
kube-system        kube-proxy-st9qd                                             1/1     Running   2 (6m56s ago)   101m
kube-system        kube-scheduler-kubernetes-1-26-0-containerd-1-6-9            1/1     Running   2 (6m56s ago)   102m
tigera-operator    tigera-operator-66654c8696-s8zpv                             1/1     Running   2 (6m13s ago)   27m
```

### versions

```shell
root@kubernetes-1-26-0-containerd-1-6-9:~# helm version
version.BuildInfo{Version:"v3.11.0", GitCommit:"472c5736ab01133de504a826bd9ee12cbe4e7904", GitTreeState:"clean", GoVersion:"go1.18.10"}
root@kubernetes-1-26-0-containerd-1-6-9:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.0", GitCommit:"b46a3f887ca979b1a5d14fd39cb1af43e7e5d12d", GitTreeState:"clean", BuildDate:"2022-12-08T19:58:30Z", GoVersion:"go1.19.4", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.7
Server Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.0", GitCommit:"b46a3f887ca979b1a5d14fd39cb1af43e7e5d12d", GitTreeState:"clean", BuildDate:"2022-12-08T19:51:45Z", GoVersion:"go1.19.4", Compiler:"gc", Platform:"linux/amd64"}
root@kubernetes-1-26-0-containerd-1-6-9:~# containerd --version
containerd github.com/containerd/containerd v1.6.9 1c90a442489720eec95342e1789ee8a5e1b9536f
root@kubernetes-1-26-0-containerd-1-6-9:~# runc --version
runc version 1.1.4
commit: v1.1.4-0-g5fd4c4d1
spec: 1.0.2-dev
go: go1.17.10
libseccomp: 2.5.4
root@kubernetes-1-26-0-containerd-1-6-9:~# cat /etc/os-release
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
root@kubernetes-1-26-0-containerd-1-6-9:~# uname -a
Linux kubernetes-1-26-0-containerd-1-6-9 5.15.0-187-generic #197-Ubuntu SMP Fri Jul 17 19:17:01 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.26.0/containerd/v1.6.9/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.26.0_containerd-v1.6.9_init:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
