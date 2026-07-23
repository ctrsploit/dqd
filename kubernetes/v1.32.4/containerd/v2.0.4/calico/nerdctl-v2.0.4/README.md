# kubernetes v1.32.4 with containerd v2.0.4, calico, nerdctl v2.0.4

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.32.4_containerd-v2.0.4-calico_nerdctl-v2.0.4_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.32.4_containerd-v2.0.4-calico_nerdctl-v2.0.4_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.32.4/containerd/v2.0.4/calico/nerdctl-v2.0.4
$ ssh dqd-kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.32.4/containerd/v2.0.4/calico/nerdctl-v2.0.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-32-4-containerd-2-0-4:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-6c98f9875-bwf2g                             1/1     Running   1 (3m40s ago)   2d20h
calico-apiserver   calico-apiserver-6c98f9875-x59p9                             1/1     Running   1 (3m40s ago)   2d20h
calico-system      calico-kube-controllers-59bf7477d-8c8v6                      1/1     Running   1 (3m40s ago)   2d20h
calico-system      calico-node-vdx7n                                            1/1     Running   1 (3m40s ago)   2d20h
calico-system      calico-typha-6749447f7d-jnw7d                                1/1     Running   1 (3m40s ago)   2d20h
calico-system      csi-node-driver-mm9sf                                        2/2     Running   2 (3m40s ago)   2d20h
kube-system        coredns-668d6bf9bc-plj7l                                     1/1     Running   1 (3m40s ago)   3d18h
kube-system        coredns-668d6bf9bc-psmlb                                     1/1     Running   1 (3m40s ago)   3d18h
kube-system        etcd-kubernetes-1-32-4-containerd-2-0-4                      1/1     Running   2 (3m40s ago)   3d18h
kube-system        kube-apiserver-kubernetes-1-32-4-containerd-2-0-4            1/1     Running   2 (3m40s ago)   3d18h
kube-system        kube-controller-manager-kubernetes-1-32-4-containerd-2-0-4   1/1     Running   2 (3m40s ago)   3d18h
kube-system        kube-proxy-n85ch                                             1/1     Running   2 (3m40s ago)   3d18h
kube-system        kube-scheduler-kubernetes-1-32-4-containerd-2-0-4            1/1     Running   2 (3m40s ago)   3d18h
tigera-operator    tigera-operator-d77bd6f45-ndgt5                              1/1     Running   1 (3m40s ago)   2d20h
```

### Deploy a pod

```shell
root@kubernetes-1-32-4-containerd-2-0-4:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-32-4-containerd-2-0-4:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          38s
```

### nerdctl

```shell
root@kubernetes-1-32-4-containerd-2-0-4:~# nerdctl run hello-world
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
root@kubernetes-1-32-4-containerd-2-0-4:~# echo 'FROM hello-world' > Dockerfile
root@kubernetes-1-32-4-containerd-2-0-4:~# nerdctl build -t foo .
root@kubernetes-1-32-4-containerd-2-0-4:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED                   PLATFORM       SIZE       BLOB SIZE
foo            latest    5ab06286eb59    Less than a second ago    linux/amd64    16.38kB    3.491kB
hello-world    latest    96498ffd522e    59 seconds ago            linux/amd64    16.38kB    4.015kB
```

### versions

```shell
root@kubernetes-1-32-4-containerd-2-0-4:~# nerdctl --version
nerdctl version 2.0.4
root@kubernetes-1-32-4-containerd-2-0-4:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.20.1 de56a3c5056341667b5bad71f414ece70b50724f
root@kubernetes-1-32-4-containerd-2-0-4:~# helm version
version.BuildInfo{Version:"v3.16.4", GitCommit:"7877b45b63f95635153b29a42c0c2f4273ec45ca", GitTreeState:"clean", GoVersion:"go1.22.7"}
root@kubernetes-1-32-4-containerd-2-0-4:~# kubectl version
Client Version: v1.32.4
Kustomize Version: v5.5.0
Server Version: v1.32.4
root@kubernetes-1-32-4-containerd-2-0-4:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.4 1a43cb6a1035441f9aca8f5666a9b3ef9e70ab20
root@kubernetes-1-32-4-containerd-2-0-4:~# runc --version
runc version 1.2.5
commit: v1.2.5-0-g59923ef1
spec: 1.2.0
go: go1.22.12
libseccomp: 2.5.5
root@kubernetes-1-32-4-containerd-2-0-4:~# cat /etc/os-release
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
root@kubernetes-1-32-4-containerd-2-0-4:~# uname -a
Linux kubernetes-1-32-4-containerd-2-0-4 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.32.4/containerd/v2.0.4/calico/nerdctl-v2.0.4
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico:ctr_v0.1.0
...
ADD https://github.com/containerd/nerdctl/releases/download/v2.0.4/nerdctl-2.0.4-linux-amd64.tar.gz /tmp/nerdctl.tar.gz
RUN tar Cxzvvf /usr/local/bin /tmp/nerdctl.tar.gz && rm /tmp/nerdctl.tar.gz
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
