# kubernetes v1.37.2 with containerd v2.4.1, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.37.2_containerd-v2.4.1_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.37.2_containerd-v2.4.1_calico:v0.1.0 | calico v3.32.2, CRDs from crd.projectcalico.org.v1 applied before tigera-operator |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.37.2_containerd-v2.4.1_calico:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.37.2/containerd/v2.4.1/calico/default
$ ssh dqd-kubernetes-v1.37.2_containerd-v2.4.1_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.37.2/containerd/v2.4.1/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Deploy a pod

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
pod/nginx created
$ kubectl --kubeconfig=kubeconfig get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          21s
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS        AGE
calico-system     calico-apiserver-75bfd46d59-fc8p5                            1/1     Running   0               145m
calico-system     calico-apiserver-75bfd46d59-zspgl                            1/1     Running   0               145m
calico-system     calico-kube-controllers-756bffd544-ndzt2                     1/1     Running   0               145m
calico-system     calico-node-2j9rc                                            1/1     Running   0               145m
calico-system     calico-typha-6d548c8958-bf29k                                1/1     Running   1 (2m47s ago)   145m
calico-system     goldmane-6cd7bbbb4b-pmwjp                                    1/1     Running   0               145m
calico-system     whisker-5dcf687c5-svjq9                                      2/2     Running   0               110s
kube-system       coredns-559f6c778d-jr64w                                     1/1     Running   0               20h
kube-system       coredns-559f6c778d-xcvk5                                     1/1     Running   0               20h
kube-system       etcd-kubernetes-1-37-2-containerd-2-4-1                      1/1     Running   2 (2m47s ago)   20h
kube-system       kube-apiserver-kubernetes-1-37-2-containerd-2-4-1            1/1     Running   2 (2m48s ago)   20h
kube-system       kube-controller-manager-kubernetes-1-37-2-containerd-2-4-1   1/1     Running   2 (2m47s ago)   20h
kube-system       kube-proxy-vkhmg                                             1/1     Running   2 (2m47s ago)   20h
kube-system       kube-scheduler-kubernetes-1-37-2-containerd-2-4-1            1/1     Running   2 (2m48s ago)   20h
tigera-operator   tigera-operator-74c8fbcbcc-9kzbc                             1/1     Running   1 (2m47s ago)   145m
```

### versions

```shell
root@kubernetes-1-37-2-containerd-2-4-1:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-37-2-containerd-2-4-1:~# kubectl version
Client Version: v1.37.2
Kustomize Version: v5.8.1
Server Version: v1.37.2
root@kubernetes-1-37-2-containerd-2-4-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.4.1 f2551031d7276a770f65f98c9b52e57e7dad07e8
root@kubernetes-1-37-2-containerd-2-4-1:~# runc --version
runc version 1.5.1
commit: v1.5.1-0-g8f2685a47
spec: 1.3.0
go: go1.25.12
libseccomp: 2.6.0
libpathrs: 0.2.5
root@kubernetes-1-37-2-containerd-2-4-1:~# cat /etc/os-release
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
root@kubernetes-1-37-2-containerd-2-4-1:~# uname -a
Linux kubernetes-1-37-2-containerd-2-4-1 6.8.0-149-generic #149-Ubuntu SMP PREEMPT_DYNAMIC Fri Oct 23 13:21:10 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.37.2/containerd/v2.4.1/calico/default
```


## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.37.2_containerd-v2.4.1_calico:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
