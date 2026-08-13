# kubernetes v1.33.1 with containerd v2.1.0, calico, nerdctl v2.1.1

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_calico_nerdctl-v2.1.1:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_calico_nerdctl-v2.1.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.1-calico_nerdctl-v2.1.1_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_calico_nerdctl-v2.1.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.1-calico_nerdctl-v2.1.1_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.1/containerd/v2.1.0/calico/nerdctl-v2.1.1
$ ssh dqd-kubernetes-v1.33.1_containerd-v2.1.0_calico_nerdctl-v2.1.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.1/containerd/v2.1.0/calico/nerdctl-v2.1.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-68f888cfb-btnvj                             1/1     Running   1 (2m19s ago)   97m
calico-apiserver   calico-apiserver-68f888cfb-gzwsb                             1/1     Running   1 (2m19s ago)   97m
calico-system      calico-kube-controllers-7599c95f78-tlvnf                     1/1     Running   1 (2m19s ago)   97m
calico-system      calico-node-2g8t4                                            1/1     Running   1 (2m19s ago)   97m
calico-system      calico-typha-7c747697f-8lnlx                                 1/1     Running   1 (2m19s ago)   97m
calico-system      csi-node-driver-9ssw7                                        2/2     Running   2 (2m19s ago)   97m
calico-system      goldmane-86cd9d999d-6pcnd                                    1/1     Running   1 (2m19s ago)   97m
calico-system      whisker-7f7c56bfb5-5mdzx                                     2/2     Running   2 (2m19s ago)   97m
kube-system        coredns-674b8bbfcf-pclnm                                     1/1     Running   1 (2m19s ago)   13h
kube-system        coredns-674b8bbfcf-w2kxj                                     1/1     Running   1 (2m19s ago)   13h
kube-system        etcd-kubernetes-1-33-1-containerd-2-1-0                      1/1     Running   2 (2m19s ago)   13h
kube-system        kube-apiserver-kubernetes-1-33-1-containerd-2-1-0            1/1     Running   2 (2m19s ago)   13h
kube-system        kube-controller-manager-kubernetes-1-33-1-containerd-2-1-0   1/1     Running   2 (2m19s ago)   13h
kube-system        kube-proxy-vksb8                                             1/1     Running   2 (2m19s ago)   13h
kube-system        kube-scheduler-kubernetes-1-33-1-containerd-2-1-0            1/1     Running   2 (2m19s ago)   13h
tigera-operator    tigera-operator-68f7c7984d-94csl                             1/1     Running   1 (2m19s ago)   97m
```

### Deploy a pod

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          28s
```

### nerdctl

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# nerdctl run hello-world
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
root@kubernetes-1-33-1-containerd-2-1-0:~# echo 'FROM hello-world' > Dockerfile
root@kubernetes-1-33-1-containerd-2-1-0:~# nerdctl build -t foo .
root@kubernetes-1-33-1-containerd-2-1-0:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED                   PLATFORM       SIZE       BLOB SIZE
foo            latest    5ab06286eb59    Less than a second ago    linux/amd64    16.38kB    3.491kB
hello-world    latest    5dd0d3e6e255    9 seconds ago             linux/amd64    16.38kB    4.015kB
```

### versions

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# nerdctl --version
nerdctl version 2.1.1
root@kubernetes-1-33-1-containerd-2-1-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.21.1 66735c67040bc80e6ed104f451683e094030a4e1
root@kubernetes-1-33-1-containerd-2-1-0:~# helm version
version.BuildInfo{Version:"v3.18.3", GitCommit:"6838ebcf265a3842d1433956e8a622e3290cf324", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl version
Client Version: v1.33.1
Kustomize Version: v5.6.0
Server Version: v1.33.1
root@kubernetes-1-33-1-containerd-2-1-0:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.0 061792f0ecf3684fb30a3a0eb006799b8c6638a7
root@kubernetes-1-33-1-containerd-2-1-0:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@kubernetes-1-33-1-containerd-2-1-0:~# cat /etc/os-release
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
root@kubernetes-1-33-1-containerd-2-1-0:~# uname -a
Linux kubernetes-1-33-1-containerd-2-1-0 6.8.0-137-generic #137-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 17 20:28:23 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.33.1/containerd/v2.1.0/calico/nerdctl-v2.1.1
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_calico:ctr_v0.1.0
...
ADD https://github.com/containerd/nerdctl/releases/download/v2.1.1/nerdctl-2.1.1-linux-amd64.tar.gz /tmp/nerdctl.tar.gz
RUN tar Cxzvvf /usr/local/bin /tmp/nerdctl.tar.gz && rm /tmp/nerdctl.tar.gz
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
