# kubernetes v1.32.2 with containerd v2.0.3, calico, nerdctl v2.0.3

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_calico_nerdctl-v2.0.3:latest | point to v0.2.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_calico_nerdctl-v2.0.3:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.32.2_containerd-v2.0.3-calico_nerdctl-v2.0.3_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_calico_nerdctl-v2.0.3:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.32.2_containerd-v2.0.3-calico_nerdctl-v2.0.3_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.32.2/containerd/v2.0.3/calico/nerdctl-v2.0.3
$ ssh dqd-kubernetes-v1.32.2_containerd-v2.0.3_calico_nerdctl-v2.0.3
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.32.2/containerd/v2.0.3/calico/nerdctl-v2.0.3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-32-2-containerd-2-0-3:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS       AGE
calico-apiserver   calico-apiserver-645d944c-h5vwp                              1/1     Running   1 (4m5s ago)   130d
calico-apiserver   calico-apiserver-645d944c-pmkz5                              1/1     Running   1 (4m5s ago)   130d
calico-system      calico-kube-controllers-768df9fb5b-rdxz9                     1/1     Running   1 (4m5s ago)   130d
calico-system      calico-node-mpxrh                                            1/1     Running   1 (4m5s ago)   130d
calico-system      calico-typha-5cdbb9c77b-66pst                                1/1     Running   1 (4m5s ago)   130d
calico-system      csi-node-driver-zbg74                                        2/2     Running   2 (4m5s ago)   130d
kube-system        coredns-668d6bf9bc-79d4n                                     1/1     Running   1 (4m5s ago)   130d
kube-system        coredns-668d6bf9bc-tm9p5                                     1/1     Running   1 (4m5s ago)   130d
kube-system        etcd-kubernetes-1-32-2-containerd-2-0-3                      1/1     Running   2 (4m5s ago)   130d
kube-system        kube-apiserver-kubernetes-1-32-2-containerd-2-0-3            1/1     Running   2 (4m5s ago)   130d
kube-system        kube-controller-manager-kubernetes-1-32-2-containerd-2-0-3   1/1     Running   2 (4m5s ago)   130d
kube-system        kube-proxy-wjpdj                                             1/1     Running   2 (4m5s ago)   130d
kube-system        kube-scheduler-kubernetes-1-32-2-containerd-2-0-3            1/1     Running   2 (4m5s ago)   130d
tigera-operator    tigera-operator-d77bd6f45-nhf92                              1/1     Running   1 (4m5s ago)   130d
```

### Deploy a pod

```shell
root@kubernetes-1-32-2-containerd-2-0-3:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-32-2-containerd-2-0-3:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          29s
```

### nerdctl

```shell
root@kubernetes-1-32-2-containerd-2-0-3:~# nerdctl run hello-world
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
root@kubernetes-1-32-2-containerd-2-0-3:~# echo 'FROM hello-world' > Dockerfile
root@kubernetes-1-32-2-containerd-2-0-3:~# nerdctl build -t foo .
root@kubernetes-1-32-2-containerd-2-0-3:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED                   PLATFORM       SIZE       BLOB SIZE
foo            latest    5ab06286eb59    Less than a second ago    linux/amd64    16.38kB    3.491kB
hello-world    latest    96498ffd522e    4 seconds ago             linux/amd64    16.38kB    4.015kB
```

### versions

```shell
root@kubernetes-1-32-2-containerd-2-0-3:~# nerdctl --version
nerdctl version 2.0.3
root@kubernetes-1-32-2-containerd-2-0-3:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.19.0 3637d1b15a13fc3cdd0c16fcf3be0845ae68f53d
root@kubernetes-1-32-2-containerd-2-0-3:~# helm version
version.BuildInfo{Version:"v3.16.4", GitCommit:"7877b45b63f95635153b29a42c0c2f4273ec45ca", GitTreeState:"clean", GoVersion:"go1.22.7"}
root@kubernetes-1-32-2-containerd-2-0-3:~# kubectl version
Client Version: v1.32.2
Kustomize Version: v5.5.0
Server Version: v1.32.2
root@kubernetes-1-32-2-containerd-2-0-3:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.3 06b99ca80cdbfbc6cc8bd567021738c9af2b36ce
root@kubernetes-1-32-2-containerd-2-0-3:~# runc --version
runc version 1.2.5
commit: v1.2.5-0-g59923ef1
spec: 1.2.0
go: go1.22.12
libseccomp: 2.5.5
root@kubernetes-1-32-2-containerd-2-0-3:~# cat /etc/os-release
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
root@kubernetes-1-32-2-containerd-2-0-3:~# uname -a
Linux kubernetes-1-32-2-containerd-2-0-3 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.32.2/containerd/v2.0.3/calico/nerdctl-v2.0.3
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_calico:ctr_v0.2.0
...
ADD https://github.com/containerd/nerdctl/releases/download/v2.0.3/nerdctl-2.0.3-linux-amd64.tar.gz /tmp/nerdctl.tar.gz
RUN tar Cxzvvf /usr/local/bin /tmp/nerdctl.tar.gz && rm /tmp/nerdctl.tar.gz
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
