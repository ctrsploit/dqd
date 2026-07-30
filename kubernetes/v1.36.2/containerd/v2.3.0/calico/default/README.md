# kubernetes v1.36.2 with containerd v2.3.0, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.2_containerd-v2.3.0_calico:latest | -> v0.1.1 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.2_containerd-v2.3.0_calico:v0.1.1 | apply CRDs from crd.projectcalico.org.v1 before installing tigera-operator (fixes v3.32.1 silent install failure) |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.2_containerd-v2.3.0_calico:v0.1.0 | calico v3.32.1 CRDs not installed; tigera-operator never came up |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.2_containerd-v2.3.0_calico:ctr_v0.1.1 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.36.2/containerd/v2.3.0/calico/default
$ ssh dqd-kubernetes-v1.36.2_containerd-v2.3.0_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.36.2/containerd/v2.3.0/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS      AGE
calico-system     calico-apiserver-6b4b4cbf4b-s5hm9                            1/1     Running   0             90m
calico-system     calico-apiserver-6b4b4cbf4b-xrvj5                            1/1     Running   0             90m
calico-system     calico-kube-controllers-6768fdf6-kfc4d                       1/1     Running   0             90m
calico-system     calico-node-9cwx5                                            1/1     Running   0             90m
calico-system     calico-typha-69496777cb-vg4dr                                1/1     Running   1 (11m ago)   90m
calico-system     goldmane-7d7d59c89-svlls                                     1/1     Running   0             90m
calico-system     whisker-8f67c469f-gzr9f                                      2/2     Running   0             9m59s
kube-system       coredns-589f44dc88-bx4pz                                     1/1     Running   0             9h
kube-system       coredns-589f44dc88-gxg5s                                     1/1     Running   0             9h
kube-system       etcd-kubernetes-1-36-2-containerd-2-3-0                      1/1     Running   2 (11m ago)   9h
kube-system       kube-apiserver-kubernetes-1-36-2-containerd-2-3-0            1/1     Running   2 (11m ago)   9h
kube-system       kube-controller-manager-kubernetes-1-36-2-containerd-2-3-0   1/1     Running   2 (11m ago)   9h
kube-system       kube-proxy-d6jcb                                             1/1     Running   2 (11m ago)   9h
kube-system       kube-scheduler-kubernetes-1-36-2-containerd-2-3-0            1/1     Running   2 (11m ago)   9h
tigera-operator   tigera-operator-57886bd678-cpsw2                             1/1     Running   1 (11m ago)   90m
```

### run a container

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
pod/nginx created
$ kubectl --kubeconfig=kubeconfig get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          5s
```

### versions

```shell
root@kubernetes-1-36-2-containerd-2-3-0:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-36-2-containerd-2-3-0:~# kubectl version
Client Version: v1.36.2
Kustomize Version: v5.8.1
Server Version: v1.36.2
root@kubernetes-1-36-2-containerd-2-3-0:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.3.0 2976f38ccbfcda5ef1364d63d60b0a304e4bf94a
root@kubernetes-1-36-2-containerd-2-3-0:~# runc --version
runc version 1.4.2
commit: v1.4.2-0-gc241c0bb
spec: 1.3.0
go: go1.25.8
libseccomp: 2.6.0
root@kubernetes-1-36-2-containerd-2-3-0:~# cat /etc/os-release
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
root@kubernetes-1-36-2-containerd-2-3-0:~# uname -a
Linux kubernetes-1-36-2-containerd-2-3-0 6.8.0-136-generic #136-Ubuntu SMP PREEMPT_DYNAMIC Wed Jul  1 21:53:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.36.2/containerd/v2.3.0/calico/default
```


### for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.36.2_containerd-v2.3.0_calico:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
