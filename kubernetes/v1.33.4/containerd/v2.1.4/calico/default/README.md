# kubernetes v1.33.4 with containerd v2.1.4, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.4-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.4-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.4/containerd/v2.1.4/calico/default
$ ssh dqd-kubernetes-v1.33.4_containerd-v2.1.4_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.4/containerd/v2.1.4/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-4-containerd-2-1-4:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS      AGE
calico-apiserver   calico-apiserver-7b9b985847-nnktq                            1/1     Running   1 (22m ago)   45m
calico-apiserver   calico-apiserver-7b9b985847-qmcwf                            1/1     Running   1 (22m ago)   45m
calico-system      calico-kube-controllers-9948f455-48f2x                       1/1     Running   1 (22m ago)   45m
calico-system      calico-node-wdx7q                                            1/1     Running   1 (22m ago)   45m
calico-system      calico-typha-7696859f7-lmpxs                                 1/1     Running   1 (22m ago)   45m
calico-system      csi-node-driver-84b8b                                        2/2     Running   2 (22m ago)   45m
calico-system      goldmane-b49dd46d7-896l9                                     1/1     Running   1 (22m ago)   45m
calico-system      whisker-7cb857c9d9-8gmml                                     2/2     Running   2 (22m ago)   44m
kube-system        coredns-674b8bbfcf-7zp9t                                     1/1     Running   1 (22m ago)   102m
kube-system        coredns-674b8bbfcf-jckkq                                     1/1     Running   1 (22m ago)   102m
kube-system        etcd-kubernetes-1-33-4-containerd-2-1-4                      1/1     Running   2 (22m ago)   102m
kube-system        kube-apiserver-kubernetes-1-33-4-containerd-2-1-4            1/1     Running   2 (22m ago)   102m
kube-system        kube-controller-manager-kubernetes-1-33-4-containerd-2-1-4   1/1     Running   2 (22m ago)   102m
kube-system        kube-proxy-4f9gj                                             1/1     Running   2 (22m ago)   102m
kube-system        kube-scheduler-kubernetes-1-33-4-containerd-2-1-4            1/1     Running   2 (22m ago)   102m
tigera-operator    tigera-operator-6d69b9b454-kvnh5                             1/1     Running   1 (22m ago)   45m
```

### Deploy a pod

```shell
root@kubernetes-1-33-4-containerd-2-1-4:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-33-4-containerd-2-1-4:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          29s
```

### versions

```shell
root@kubernetes-1-33-4-containerd-2-1-4:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-4-containerd-2-1-4:~# kubectl version
Client Version: v1.33.4
Kustomize Version: v5.6.0
Server Version: v1.33.4
root@kubernetes-1-33-4-containerd-2-1-4:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.4 75cb2b7193e4e490e9fbdc236c0e811ccaba3376
root@kubernetes-1-33-4-containerd-2-1-4:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@kubernetes-1-33-4-containerd-2-1-4:~# cat /etc/os-release
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
root@kubernetes-1-33-4-containerd-2-1-4:~# uname -a
Linux kubernetes-1-33-4-containerd-2-1-4 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.33.4/containerd/v2.1.4/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_init:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
