# kubernetes v1.35.0 with containerd v2.2.0, calico, nerdctl v2.2.0

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico_nerdctl-v2.2.0:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico_nerdctl-v2.2.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.35.0-calico_nerdctl-v2.2.0_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico_nerdctl-v2.2.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.35.0-calico_nerdctl-v2.2.0_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.35.0/containerd/v2.2.0/calico/nerdctl-v2.2.0
$ ssh dqd-kubernetes-v1.35.0_containerd-v2.2.0_calico_nerdctl-v2.2.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.35.0/containerd/v2.2.0/calico/nerdctl-v2.2.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-35-0-containerd-2-2-0:~# kubectl get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS      AGE
calico-system     calico-apiserver-77786b4bcc-2rbdf                            1/1     Running   1 (95s ago)   167m
calico-system     calico-apiserver-77786b4bcc-p4mw7                            1/1     Running   1 (95s ago)   167m
calico-system     calico-kube-controllers-796548b77c-5gwnz                     1/1     Running   1 (95s ago)   167m
calico-system     calico-node-pbxld                                            1/1     Running   1 (95s ago)   167m
calico-system     calico-typha-569f48d879-dq8gw                                1/1     Running   1 (95s ago)   167m
calico-system     goldmane-58f96f7c58-qkgb5                                    1/1     Running   1 (95s ago)   167m
calico-system     whisker-6c7cd99f5d-c7hs5                                     2/2     Running   2 (95s ago)   167m
kube-system       coredns-7d764666f9-8wbtr                                     1/1     Running   1 (95s ago)   3h24m
kube-system       coredns-7d764666f9-mv56q                                     1/1     Running   1 (95s ago)   3h24m
kube-system       etcd-kubernetes-1-35-0-containerd-2-2-0                      1/1     Running   2 (95s ago)   3h24m
kube-system       kube-apiserver-kubernetes-1-35-0-containerd-2-2-0            1/1     Running   2 (95s ago)   3h24m
kube-system       kube-controller-manager-kubernetes-1-35-0-containerd-2-2-0   1/1     Running   2 (95s ago)   3h24m
kube-system       kube-proxy-868c7                                             1/1     Running   2 (95s ago)   3h24m
kube-system       kube-scheduler-kubernetes-1-35-0-containerd-2-2-0            1/1     Running   2 (95s ago)   3h24m
tigera-operator   tigera-operator-6cf4cccc57-9pkgq                             1/1     Running   1 (95s ago)   167m
```

### Deploy a pod

```shell
root@kubernetes-1-35-0-containerd-2-2-0:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-35-0-containerd-2-2-0:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          23s
```

### nerdctl

```shell
root@kubernetes-1-35-0-containerd-2-2-0:~# nerdctl run hello-world
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
root@kubernetes-1-35-0-containerd-2-2-0:~# echo 'FROM hello-world' > Dockerfile
root@kubernetes-1-35-0-containerd-2-2-0:~# nerdctl build -t foo .
root@kubernetes-1-35-0-containerd-2-2-0:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED                   PLATFORM       SIZE       BLOB SIZE
foo            latest    5ab06286eb59    Less than a second ago    linux/amd64    16.38kB    3.491kB
hello-world    latest    96498ffd522e    36 seconds ago            linux/amd64    16.38kB    4.015kB
```

### versions

```shell
root@kubernetes-1-35-0-containerd-2-2-0:~# nerdctl --version
nerdctl version 2.2.0
root@kubernetes-1-35-0-containerd-2-2-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.25.2 dcc0fe5e96ae78919b30057d0804c52f13a2eb7e
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
make all ENV=kubernetes/v1.35.0/containerd/v2.2.0/calico/nerdctl-v2.2.0
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:ctr_v0.1.0
...
ADD https://github.com/containerd/nerdctl/releases/download/v2.2.0/nerdctl-2.2.0-linux-amd64.tar.gz /tmp/nerdctl.tar.gz
RUN tar Cxzvvf /usr/local/bin /tmp/nerdctl.tar.gz && rm /tmp/nerdctl.tar.gz
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
