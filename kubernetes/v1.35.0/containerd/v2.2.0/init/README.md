# kubernetes v1.35.0 with containerd v2.2.0

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_init:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_init:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_init:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.35.0/containerd/v2.2.0/init
$ ssh dqd-kubernetes-v1.35.0_containerd-v2.2.0_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.35.0/containerd/v2.2.0/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS      AGE
kube-system   coredns-7d764666f9-8wbtr                                     0/1     Pending   0             14m
kube-system   coredns-7d764666f9-mv56q                                     0/1     Pending   0             14m
kube-system   etcd-kubernetes-1-35-0-containerd-2-2-0                      1/1     Running   1 (52s ago)   15m
kube-system   kube-apiserver-kubernetes-1-35-0-containerd-2-2-0            1/1     Running   1 (52s ago)   15m
kube-system   kube-controller-manager-kubernetes-1-35-0-containerd-2-2-0   1/1     Running   1 (52s ago)   15m
kube-system   kube-proxy-868c7                                             1/1     Running   1 (52s ago)   14m
kube-system   kube-scheduler-kubernetes-1-35-0-containerd-2-2-0            1/1     Running   1 (52s ago)   15m
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
make all ENV=kubernetes/v1.35.0/containerd/v2.2.0/init
```


## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_init:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug

## Tricks

### 1. Use a cache mount to avoid overlayfs-on-overlayfs errors

If you encounter the following error:

```
[ 2237.540485] overlayfs: filesystem on '/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots/72/fs' not supported as upperdir
```

it typically means an **overlayfs** is being mounted over another **overlayfs**.
You can solve this issue by using a **cache mount** within your build process.

**Example:**

```Dockerfile
# copy image snapshots
RUN --mount=type=cache,id=kubernetes-v1.35.0_containerd-v2.2.0-snapshots,target=/trick \
    cp -a /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/* /trick/
# kubeadm init under ext4 fs
RUN --mount=type=cache,id=kubernetes-v1.35.0_containerd-v2.2.0-snapshots,target=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs \
    # fix kube-proxy `Failed to load kernel module`
    --mount=type=bind,src=/modules,target=/lib/modules \
    --security=insecure \
    ["/sbin/init", "--log-target=kmsg"]
# skip overlayfs whiteout files (c 0,0)
RUN --mount=type=cache,id=kubernetes-v1.35.0_containerd-v2.2.0-snapshots,target=/trick \
    # all these files are safe to delete, list each file path here for more clear
    rm /trick/snapshots/*/work/work/#* && \
    # use tar to preserve file capabilities
    tar -C /trick -cf - . | tar -C /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/ -xf -
```

This approach stores containerd snapshots in a temp cache directory, avoiding nested overlayfs layers and improving build consistency.

> NOTE: mknod is not allowed on overlayfs, even when running as a privileged container.
