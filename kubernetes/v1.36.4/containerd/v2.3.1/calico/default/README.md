# kubernetes v1.36.4 with containerd v2.3.1, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.1_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.1_calico:v0.1.0 | calico v3.32.2, CRDs from crd.projectcalico.org.v1 applied before tigera-operator |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.1_calico:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.36.4/containerd/v2.3.1/calico/default
$ ssh dqd-kubernetes-v1.36.4_containerd-v2.3.1_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.36.4/containerd/v2.3.1/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Deploy a pod

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
pod/nginx created
$ kubectl --kubeconfig=kubeconfig get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          5s
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS      AGE
calico-system     calico-apiserver-6476954998-gclrs                            1/1     Running   0             40m
calico-system     calico-apiserver-6476954998-p9lnq                            1/1     Running   0             40m
calico-system     calico-kube-controllers-5c975689c8-nh6lb                     1/1     Running   0             40m
calico-system     calico-node-59tkh                                            1/1     Running   0             40m
calico-system     calico-typha-6cff8cf689-wqj8x                                1/1     Running   1 (17m ago)   40m
calico-system     goldmane-686c69bb96-jstmz                                    1/1     Running   0             40m
calico-system     whisker-d7cf48669-dk7z8                                      2/2     Running   0             16m
kube-system       coredns-589f44dc88-b6h9v                                     1/1     Running   0             93m
kube-system       coredns-589f44dc88-k65ds                                     1/1     Running   0             93m
kube-system       etcd-kubernetes-1-36-4-containerd-2-3-1                      1/1     Running   2 (17m ago)   93m
kube-system       kube-apiserver-kubernetes-1-36-4-containerd-2-3-1            1/1     Running   2 (17m ago)   93m
kube-system       kube-controller-manager-kubernetes-1-36-4-containerd-2-3-1   1/1     Running   2 (17m ago)   93m
kube-system       kube-proxy-wz9w5                                             1/1     Running   2 (17m ago)   93m
kube-system       kube-scheduler-kubernetes-1-36-4-containerd-2-3-1            1/1     Running   2 (17m ago)   93m
tigera-operator   tigera-operator-d78bcd95d-2j7r7                              1/1     Running   1 (17m ago)   40m
```

### versions

```shell
root@kubernetes-1-36-4-containerd-2-3-1:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-36-4-containerd-2-3-1:~# kubectl version
Client Version: v1.36.4
Kustomize Version: v5.8.1
Server Version: v1.36.4
root@kubernetes-1-36-4-containerd-2-3-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.3.1 64b425cf570b3b8dd1d4cc46da7c1fce65c6651a
root@kubernetes-1-36-4-containerd-2-3-1:~# runc --version
runc version 1.4.2
commit: v1.4.2-0-gc241c0bb
spec: 1.3.0
go: go1.25.8
libseccomp: 2.6.0
root@kubernetes-1-36-4-containerd-2-3-1:~# cat /etc/os-release
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
root@kubernetes-1-36-4-containerd-2-3-1:~# uname -a
Linux kubernetes-1-36-4-containerd-2-3-1 6.8.0-138-generic #138-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 31 22:41:49 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.36.4/containerd/v2.3.1/calico/default
```


## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.1_calico:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
