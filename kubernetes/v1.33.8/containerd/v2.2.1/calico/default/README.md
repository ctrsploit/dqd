# kubernetes v1.33.8 with containerd v2.2.1, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.8-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.8-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.8/containerd/v2.2.1/calico/default
$ ssh dqd-kubernetes-v1.33.8_containerd-v2.2.1_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.8/containerd/v2.2.1/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-78fc8ccbf5-4lnp9                            1/1     Running   1 (6m25s ago)   32m
calico-apiserver   calico-apiserver-78fc8ccbf5-grwq8                            1/1     Running   1 (6m25s ago)   32m
calico-system      calico-kube-controllers-59df557df8-lq7nd                     1/1     Running   1 (6m25s ago)   32m
calico-system      calico-node-b54sq                                            1/1     Running   1 (6m25s ago)   32m
calico-system      calico-typha-85f6559796-66ggn                                1/1     Running   1 (6m25s ago)   32m
calico-system      csi-node-driver-qsxnx                                        2/2     Running   2 (6m25s ago)   32m
calico-system      goldmane-b49dd46d7-hnz9m                                     1/1     Running   1 (6m25s ago)   32m
calico-system      whisker-555567d487-2bhxq                                     2/2     Running   2 (6m25s ago)   31m
kube-system        coredns-674b8bbfcf-nt7wv                                     1/1     Running   1 (6m25s ago)   144m
kube-system        coredns-674b8bbfcf-xz8sm                                     1/1     Running   1 (6m25s ago)   144m
kube-system        etcd-kubernetes-1-33-8-containerd-2-2-1                      1/1     Running   2 (6m25s ago)   145m
kube-system        kube-apiserver-kubernetes-1-33-8-containerd-2-2-1            1/1     Running   2 (6m25s ago)   145m
kube-system        kube-controller-manager-kubernetes-1-33-8-containerd-2-2-1   1/1     Running   2 (6m25s ago)   145m
kube-system        kube-proxy-jhz6r                                             1/1     Running   2 (6m25s ago)   144m
kube-system        kube-scheduler-kubernetes-1-33-8-containerd-2-2-1            1/1     Running   2 (6m25s ago)   145m
tigera-operator    tigera-operator-6d69b9b454-pxpf8                             1/1     Running   1 (6m25s ago)   32m
```

### Deploy a pod

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          29s
```

### versions

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl version
Client Version: v1.33.8
Kustomize Version: v5.6.0
Server Version: v1.33.8
root@kubernetes-1-33-8-containerd-2-2-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.2.1 dea7da592f5d1d2b7755e3a161be07f43fad8f75
root@kubernetes-1-33-8-containerd-2-2-1:~# runc --version
runc version 1.3.4
commit: v1.3.4-0-gd6d73eb8
spec: 1.2.1
go: go1.24.10
libseccomp: 2.5.6
root@kubernetes-1-33-8-containerd-2-2-1:~# cat /etc/os-release
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
root@kubernetes-1-33-8-containerd-2-2-1:~# uname -a
Linux kubernetes-1-33-8-containerd-2-2-1 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.33.8/containerd/v2.2.1/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_init:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
