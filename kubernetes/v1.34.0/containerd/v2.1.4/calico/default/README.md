# kubernetes v1.34.0 with containerd v2.1.4, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_calico:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_calico:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.34.0/containerd/v2.1.4/calico/default
$ ssh dqd-kubernetes-v1.34.0_containerd-v2.1.4_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.34.0/containerd/v2.1.4/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS      AGE
calico-apiserver   calico-apiserver-799fdf64b5-5hdd9                            1/1     Running   1 (11m ago)   29m
calico-apiserver   calico-apiserver-799fdf64b5-sqvmv                            1/1     Running   1 (11m ago)   29m
calico-system      calico-kube-controllers-679897cb9c-6mkkx                     1/1     Running   1 (11m ago)   29m
calico-system      calico-node-pjv9d                                            1/1     Running   1 (11m ago)   29m
calico-system      calico-typha-789987d96-l2mc8                                 1/1     Running   1 (11m ago)   29m
calico-system      csi-node-driver-7hk9p                                        2/2     Running   2 (11m ago)   28m
calico-system      goldmane-64654bd66b-ccsr7                                    1/1     Running   1 (11m ago)   29m
calico-system      whisker-7f7c65ff79-jfwws                                     2/2     Running   2 (11m ago)   28m
kube-system        coredns-66bc5c9577-kwsw2                                     1/1     Running   1 (11m ago)   13h
kube-system        coredns-66bc5c9577-kzk86                                     1/1     Running   1 (11m ago)   13h
kube-system        etcd-kubernetes-1-34-0-containerd-2-1-4                      1/1     Running   2 (11m ago)   13h
kube-system        kube-apiserver-kubernetes-1-34-0-containerd-2-1-4            1/1     Running   2 (11m ago)   13h
kube-system        kube-controller-manager-kubernetes-1-34-0-containerd-2-1-4   1/1     Running   2 (11m ago)   13h
kube-system        kube-proxy-wq5lv                                             1/1     Running   2 (11m ago)   13h
kube-system        kube-scheduler-kubernetes-1-34-0-containerd-2-1-4            1/1     Running   2 (11m ago)   13h
tigera-operator    tigera-operator-65cdcdfd6d-25768                             1/1     Running   1 (11m ago)   29m
```

### run a container

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
pod/nginx created
$ kubectl --kubeconfig=kubeconfig get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          24s
```

### versions

```shell
root@kubernetes-1-34-0-containerd-2-1-4:~# helm version
version.BuildInfo{Version:"v3.19.0", GitCommit:"3d8990f0836691f0229297773f3524598f46bda6", GitTreeState:"clean", GoVersion:"go1.24.7"}
root@kubernetes-1-34-0-containerd-2-1-4:~# kubectl version
Client Version: v1.34.0
Kustomize Version: v5.7.1
Server Version: v1.34.0
root@kubernetes-1-34-0-containerd-2-1-4:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.4 75cb2b7193e4e490e9fbdc236c0e811ccaba3376
root@kubernetes-1-34-0-containerd-2-1-4:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@kubernetes-1-34-0-containerd-2-1-4:~# cat /etc/os-release
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
root@kubernetes-1-34-0-containerd-2-1-4:~# uname -a
Linux kubernetes-1-34-0-containerd-2-1-4 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.34.0/containerd/v2.1.4/calico/default
```


### for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_init:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug

## Notes

This base image uses the **fuse-overlayfs** containerd snapshotter, so there is no
overlayfs-on-overlayfs problem during build. The Calico install therefore runs directly
under `/sbin/init` (no snapshot cache mount), unlike the overlayfs-based
v1.32.x / v1.35.x bases which need the snapshot cache trick.
