# kubernetes v1.36.4 with containerd v2.3.2, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:latest | point to v0.1.2 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:v0.1.2 | calico v3.32.2, CRDs from crd.projectcalico.org.v1 applied before tigera-operator |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:ctr_v0.1.2 | - |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:v0.1.0 | CI failed: missing ssh_config entry |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.36.4/containerd/v2.3.2/calico/default
$ ssh dqd-kubernetes-v1.36.4_containerd-v2.3.2_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.36.4/containerd/v2.3.2/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Deploy a pod

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
pod/nginx created
$ kubectl --kubeconfig=kubeconfig get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          25s
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS        AGE
calico-system     calico-apiserver-5f9456867b-bz7w8                            1/1     Running   0               2d11h
calico-system     calico-apiserver-5f9456867b-fp9dp                            1/1     Running   0               2d11h
calico-system     calico-kube-controllers-6b459975bb-h9tgf                     1/1     Running   0               2d11h
calico-system     calico-node-g879t                                            1/1     Running   0               2d11h
calico-system     calico-typha-7479894747-2js6d                                1/1     Running   1 (2m52s ago)   2d11h
calico-system     goldmane-686c69bb96-tjd6d                                    1/1     Running   0               2d11h
calico-system     whisker-8c5b4f589-fs4cx                                      2/2     Running   0               100s
default           nginx                                                        1/1     Running   0               42s
kube-system       coredns-589f44dc88-5pzgj                                     1/1     Running   0               2d12h
kube-system       coredns-589f44dc88-hbnr4                                     1/1     Running   0               2d12h
kube-system       etcd-kubernetes-1-36-4-containerd-2-3-2                      1/1     Running   2 (2m52s ago)   2d12h
kube-system       kube-apiserver-kubernetes-1-36-4-containerd-2-3-2            1/1     Running   2 (2m52s ago)   2d12h
kube-system       kube-controller-manager-kubernetes-1-36-4-containerd-2-3-2   1/1     Running   2 (2m52s ago)   2d12h
kube-system       kube-proxy-rp6nv                                             1/1     Running   2 (2m52s ago)   2d12h
kube-system       kube-scheduler-kubernetes-1-36-4-containerd-2-3-2            1/1     Running   2 (2m52s ago)   2d12h
tigera-operator   tigera-operator-d78bcd95d-rvzbs                              1/1     Running   1 (2m52s ago)   2d11h
```

### versions

```shell
root@kubernetes-1-36-4-containerd-2-3-2:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-36-4-containerd-2-3-2:~# kubectl version
Client Version: v1.36.4
Kustomize Version: v5.8.1
Server Version: v1.36.4
root@kubernetes-1-36-4-containerd-2-3-2:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.3.2 fff62f14765df376e5fc36f5a8f8e795b5670f61
root@kubernetes-1-36-4-containerd-2-3-2:~# runc --version
runc version 1.4.3
commit: v1.4.3-0-gbb14dabeb
spec: 1.3.0
go: go1.25.11
libseccomp: 2.6.0
root@kubernetes-1-36-4-containerd-2-3-2:~# cat /etc/os-release
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
root@kubernetes-1-36-4-containerd-2-3-2:~# uname -a
Linux kubernetes-1-36-4-containerd-2-3-2 6.8.0-139-generic #139-Ubuntu SMP PREEMPT_DYNAMIC Sat Aug  1 03:52:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.36.4/containerd/v2.3.2/calico/default
```


## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:ctr_v0.1.2
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
