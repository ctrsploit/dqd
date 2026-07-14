# kubernetes v1.34.0 with containerd v2.1.4, calico, nerdctl v2.1.4

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_calico_nerdctl-v2.1.4:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_calico_nerdctl-v2.1.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.34.0-calico_nerdctl-v2.1.4_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_calico_nerdctl-v2.1.4:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.34.0-calico_nerdctl-v2.1.4_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.34.0/containerd/v2.1.4/calico/nerdctl-v2.1.4
$ ssh dqd-kubernetes-v1.34.0_containerd-v2.1.4_calico_nerdctl-v2.1.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.34.0/containerd/v2.1.4/calico/nerdctl-v2.1.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-34-0-containerd-2-1-4:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS      AGE
calico-apiserver   calico-apiserver-799fdf64b5-5hdd9                            1/1     Running   1 (15m ago)   72m
calico-apiserver   calico-apiserver-799fdf64b5-sqvmv                            1/1     Running   1 (15m ago)   73m
calico-system      calico-kube-controllers-679897cb9c-6mkkx                     1/1     Running   1 (15m ago)   73m
calico-system      calico-node-pjv9d                                            1/1     Running   1 (15m ago)   73m
calico-system      calico-typha-789987d96-l2mc8                                 1/1     Running   1 (15m ago)   73m
calico-system      csi-node-driver-7hk9p                                        2/2     Running   2 (15m ago)   73m
calico-system      goldmane-64654bd66b-ccsr7                                    1/1     Running   1 (15m ago)   73m
calico-system      whisker-7f7c65ff79-jfwws                                     2/2     Running   2 (15m ago)   73m
kube-system        coredns-66bc5c9577-kwsw2                                     1/1     Running   1 (15m ago)   14h
kube-system        coredns-66bc5c9577-kzk86                                     1/1     Running   1 (15m ago)   14h
kube-system        etcd-kubernetes-1-34-0-containerd-2-1-4                      1/1     Running   2 (15m ago)   14h
kube-system        kube-apiserver-kubernetes-1-34-0-containerd-2-1-4            1/1     Running   2 (15m ago)   14h
kube-system        kube-controller-manager-kubernetes-1-34-0-containerd-2-1-4   1/1     Running   2 (15m ago)   14h
kube-system        kube-proxy-wq5lv                                             1/1     Running   2 (15m ago)   14h
kube-system        kube-scheduler-kubernetes-1-34-0-containerd-2-1-4            1/1     Running   2 (15m ago)   14h
tigera-operator    tigera-operator-65cdcdfd6d-25768                             1/1     Running   1 (15m ago)   73m
```

### Deploy a pod

```shell
root@kubernetes-1-34-0-containerd-2-1-4:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-34-0-containerd-2-1-4:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          30s
```

### nerdctl

```shell
root@kubernetes-1-34-0-containerd-2-1-4:~# nerdctl run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
root@kubernetes-1-34-0-containerd-2-1-4:~# echo 'FROM hello-world' > Dockerfile
root@kubernetes-1-34-0-containerd-2-1-4:~# nerdctl build -t foo .
root@kubernetes-1-34-0-containerd-2-1-4:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED           PLATFORM       SIZE       BLOB SIZE
foo            latest    5ab06286eb59    27 seconds ago    linux/amd64    16.38kB    3.491kB
hello-world    latest    96498ffd522e    32 seconds ago    linux/amd64    16.38kB    4.015kB
```

### versions

```shell
root@kubernetes-1-34-0-containerd-2-1-4:~# nerdctl --version
nerdctl version 2.1.4
root@kubernetes-1-34-0-containerd-2-1-4:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.24.0 b772c318368090fb2ffc9c0fed92e0a35bf82389
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
make all ENV=kubernetes/v1.34.0/containerd/v2.1.4/calico/nerdctl-v2.1.4
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_calico:ctr_v0.1.0
...
ADD https://github.com/containerd/nerdctl/releases/download/v2.1.4/nerdctl-2.1.4-linux-amd64.tar.gz /tmp/nerdctl.tar.gz
RUN tar Cxzvvf /usr/local/bin /tmp/nerdctl.tar.gz && rm /tmp/nerdctl.tar.gz
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
