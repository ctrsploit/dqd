# kubernetes v1.33.3 with containerd v2.1.3, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.3_calico:latest | point to v0.1.1 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.3_calico:v0.1.1 | use canonical whiteout cleanup (find -type c -delete) |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.3_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.3_containerd-v2.1.3-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.3_calico:ctr_v0.1.1 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.3_containerd-v2.1.3-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.3/containerd/v2.1.3/calico/default
$ ssh dqd-kubernetes-v1.33.3_containerd-v2.1.3_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.3/containerd/v2.1.3/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-3-containerd-2-1-3:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS      AGE
calico-apiserver   calico-apiserver-5c5cb5b56f-9flf8                            1/1     Running   1 (16m ago)   46m
calico-apiserver   calico-apiserver-5c5cb5b56f-vzpk2                            1/1     Running   1 (16m ago)   46m
calico-system      calico-kube-controllers-5bd4b5b787-9t442                     1/1     Running   1 (16m ago)   46m
calico-system      calico-node-q65x4                                            1/1     Running   1 (16m ago)   46m
calico-system      calico-typha-57d4b86c5d-t9wsk                                1/1     Running   1 (16m ago)   46m
calico-system      csi-node-driver-vvb8g                                        2/2     Running   2 (16m ago)   46m
calico-system      goldmane-b49dd46d7-g52p4                                     1/1     Running   1 (16m ago)   46m
calico-system      whisker-5cd854df4f-2bd4v                                     2/2     Running   2 (16m ago)   46m
kube-system        coredns-674b8bbfcf-6dsw5                                     1/1     Running   1 (16m ago)   5d6h
kube-system        coredns-674b8bbfcf-tjk5x                                     1/1     Running   1 (16m ago)   5d6h
kube-system        etcd-kubernetes-1-33-3-containerd-2-1-3                      1/1     Running   2 (16m ago)   5d6h
kube-system        kube-apiserver-kubernetes-1-33-3-containerd-2-1-3            1/1     Running   2 (16m ago)   5d6h
kube-system        kube-controller-manager-kubernetes-1-33-3-containerd-2-1-3   1/1     Running   2 (16m ago)   5d6h
kube-system        kube-proxy-9prbv                                             1/1     Running   2 (16m ago)   5d6h
kube-system        kube-scheduler-kubernetes-1-33-3-containerd-2-1-3            1/1     Running   2 (16m ago)   5d6h
tigera-operator    tigera-operator-6d69b9b454-s67h6                             1/1     Running   1 (16m ago)   46m
```

### Deploy a pod

```shell
root@kubernetes-1-33-3-containerd-2-1-3:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-33-3-containerd-2-1-3:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          4s
```

### versions

```shell
root@kubernetes-1-33-3-containerd-2-1-3:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-3-containerd-2-1-3:~# kubectl version
Client Version: v1.33.3
Kustomize Version: v5.6.0
Server Version: v1.33.3
root@kubernetes-1-33-3-containerd-2-1-3:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.3 c787fb98911740dd3ff2d0e45ce88cdf01410486
root@kubernetes-1-33-3-containerd-2-1-3:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@kubernetes-1-33-3-containerd-2-1-3:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@kubernetes-1-33-3-containerd-2-1-3:~# uname -a
Linux kubernetes-1-33-3-containerd-2-1-3 6.8.0-136-generic #136-Ubuntu SMP PREEMPT_DYNAMIC Wed Jul  1 21:53:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.33.3/containerd/v2.1.3/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.3_init:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
