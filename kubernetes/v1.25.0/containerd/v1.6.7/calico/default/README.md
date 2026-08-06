# Kubernetes v1.25.0 with containerd v1.6.7, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_calico:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.25.0-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.25.0-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.25.0/containerd/v1.6.7/calico/default
$ ssh dqd-kubernetes-v1.25.0_containerd-v1.6.7_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.25.0/containerd/v1.6.7/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-25-0-containerd-1-6-7:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS      AGE
calico-apiserver   calico-apiserver-7b56577cd7-6bm2t                            1/1     Running   1 (17m ago)   92m
calico-apiserver   calico-apiserver-7b56577cd7-fxlkt                            1/1     Running   1 (17m ago)   92m
calico-system      calico-kube-controllers-6b57db7fd6-nll5j                     1/1     Running   1 (17m ago)   93m
calico-system      calico-node-c4fss                                            1/1     Running   1 (17m ago)   93m
calico-system      calico-typha-6ccbb888-k84w2                                  1/1     Running   1 (17m ago)   93m
kube-system        coredns-565d847f94-b4858                                     1/1     Running   1 (17m ago)   159m
kube-system        coredns-565d847f94-ck6mn                                     1/1     Running   1 (17m ago)   159m
kube-system        etcd-kubernetes-1-25-0-containerd-1-6-7                      1/1     Running   2 (17m ago)   159m
kube-system        kube-apiserver-kubernetes-1-25-0-containerd-1-6-7            1/1     Running   2 (17m ago)   159m
kube-system        kube-controller-manager-kubernetes-1-25-0-containerd-1-6-7   1/1     Running   2 (17m ago)   159m
kube-system        kube-proxy-crh69                                             1/1     Running   2 (17m ago)   159m
kube-system        kube-scheduler-kubernetes-1-25-0-containerd-1-6-7            1/1     Running   2 (17m ago)   159m
tigera-operator    tigera-operator-6bb5985474-cbndn                             1/1     Running   2 (16m ago)   93m
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
make all ENV=kubernetes/v1.25.0/containerd/v1.6.7/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_init:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
