# kubernetes v1.33.7 with containerd v2.1.5, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.7_containerd-v2.1.5_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.7_containerd-v2.1.5_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.7-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.7_containerd-v2.1.5_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.7-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.7/containerd/v2.1.5/calico/default
$ ssh dqd-kubernetes-v1.33.7_containerd-v2.1.5_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.7/containerd/v2.1.5/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-7-containerd-2-1-5:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-668f898bfc-b998q                            1/1     Running   1 (4m56s ago)   31m
calico-apiserver   calico-apiserver-668f898bfc-fvxl4                            1/1     Running   1 (4m56s ago)   31m
calico-system      calico-kube-controllers-7b55c5c7d8-rwt9w                     1/1     Running   1 (4m56s ago)   31m
calico-system      calico-node-ggcxs                                            1/1     Running   1 (4m56s ago)   31m
calico-system      calico-typha-6586b688fc-cmg79                                1/1     Running   1 (4m56s ago)   31m
calico-system      csi-node-driver-d6bfw                                        2/2     Running   2 (4m56s ago)   31m
calico-system      goldmane-b49dd46d7-r98pn                                     1/1     Running   1 (4m56s ago)   31m
calico-system      whisker-58c674c698-rss4j                                     2/2     Running   2 (4m56s ago)   30m
kube-system        coredns-674b8bbfcf-jffxp                                     1/1     Running   1 (4m56s ago)   22h
kube-system        coredns-674b8bbfcf-qfnrb                                     1/1     Running   1 (4m56s ago)   22h
kube-system        etcd-kubernetes-1-33-7-containerd-2-1-5                      1/1     Running   2 (4m56s ago)   22h
kube-system        kube-apiserver-kubernetes-1-33-7-containerd-2-1-5            1/1     Running   2 (4m56s ago)   22h
kube-system        kube-controller-manager-kubernetes-1-33-7-containerd-2-1-5   1/1     Running   2 (4m56s ago)   22h
kube-system        kube-proxy-t9dd6                                             1/1     Running   2 (4m56s ago)   22h
kube-system        kube-scheduler-kubernetes-1-33-7-containerd-2-1-5            1/1     Running   2 (4m56s ago)   22h
tigera-operator    tigera-operator-6d69b9b454-nb42l                             1/1     Running   1 (4m56s ago)   31m
```

### Deploy a pod

```shell
root@kubernetes-1-33-7-containerd-2-1-5:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-33-7-containerd-2-1-5:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          17s
```

### versions

```shell
root@kubernetes-1-33-7-containerd-2-1-5:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-7-containerd-2-1-5:~# kubectl version
Client Version: v1.33.7
Kustomize Version: v5.6.0
Server Version: v1.33.7
root@kubernetes-1-33-7-containerd-2-1-5:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.5 fcd43222d6b07379a4be9786bda52438f0dd16a1
root@kubernetes-1-33-7-containerd-2-1-5:~# runc --version
runc version 1.3.3
commit: v1.3.3-0-gd842d771
spec: 1.2.1
go: go1.23.12
libseccomp: 2.5.6
root@kubernetes-1-33-7-containerd-2-1-5:~# cat /etc/os-release
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
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-of-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@kubernetes-1-33-7-containerd-2-1-5:~# uname -a
Linux kubernetes-1-33-7-containerd-2-1-5 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.33.7/containerd/v2.1.5/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.7_containerd-v2.1.5_init:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
