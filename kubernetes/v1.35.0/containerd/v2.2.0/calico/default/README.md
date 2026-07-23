# kubernetes v1.35.0 with containerd v2.2.0, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.35.0/containerd/v2.2.0/calico/default
$ ssh dqd-kubernetes-v1.35.0_containerd-v2.2.0_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.35.0/containerd/v2.2.0/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS      AGE
calico-system     calico-apiserver-77786b4bcc-2rbdf                            1/1     Running   1 (85s ago)   36m
calico-system     calico-apiserver-77786b4bcc-p4mw7                            1/1     Running   1 (85s ago)   36m
calico-system     calico-kube-controllers-796548b77c-5gwnz                     1/1     Running   1 (85s ago)   36m
calico-system     calico-node-pbxld                                            1/1     Running   1 (85s ago)   36m
calico-system     calico-typha-569f48d879-dq8gw                                1/1     Running   1 (85s ago)   36m
calico-system     goldmane-58f96f7c58-qkgb5                                    1/1     Running   1 (85s ago)   36m
calico-system     whisker-6c7cd99f5d-c7hs5                                     2/2     Running   2 (85s ago)   36m
kube-system       coredns-7d764666f9-8wbtr                                     1/1     Running   1 (85s ago)   73m
kube-system       coredns-7d764666f9-mv56q                                     1/1     Running   1 (85s ago)   73m
kube-system       etcd-kubernetes-1-35-0-containerd-2-2-0                      1/1     Running   2 (85s ago)   73m
kube-system       kube-apiserver-kubernetes-1-35-0-containerd-2-2-0            1/1     Running   2 (85s ago)   73m
kube-system       kube-controller-manager-kubernetes-1-35-0-containerd-2-2-0   1/1     Running   2 (85s ago)   73m
kube-system       kube-proxy-868c7                                             1/1     Running   2 (85s ago)   73m
kube-system       kube-scheduler-kubernetes-1-35-0-containerd-2-2-0            1/1     Running   2 (85s ago)   73m
tigera-operator   tigera-operator-6cf4cccc57-9pkgq                             1/1     Running   1 (85s ago)   36m
```

### run a container

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
pod/nginx created
$ kubectl --kubeconfig=kubeconfig get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          47s
```

### versions

```shell
root@kubernetes-1-35-0-containerd-2-2-0:~# helm version
version.BuildInfo{Version:"v4.0.4", GitCommit:"8650e1dad9e6ae38b41f60b712af9218a0d8cc11", GitTreeState:"clean", GoVersion:"go1.25.5", KubeClientVersion:"v1.34"}
root@kubernetes-1-35-0-containerd-2-2-0:~# kubectl version
Client Version: v1.35.0
Kustomize Version: v5.7.1
Server Version: v1.35.0
root@kubernetes-1-35-0-containerd-2-2-0:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.2.0 1c4457e00facac03ce1d75f7b6777a7a851e5c41
root@kubernetes-1-35-0-containerd-2-2-0:~# runc --version
runc version 1.3.3
commit: v1.3.3-0-gd842d771
spec: 1.2.1
go: go1.23.12
libseccomp: 2.5.6
root@kubernetes-1-35-0-containerd-2-2-0:~# cat /etc/os-release
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
root@kubernetes-1-35-0-containerd-2-2-0:~# uname -a
Linux kubernetes-1-35-0-containerd-2-2-0 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.35.0/containerd/v2.2.0/calico/default
```


### for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
