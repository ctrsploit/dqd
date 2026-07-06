# nerdctl v2.0.4 with runc v1.2.5 debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.0.4_runc-v1.2.5-debug:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.0.4_runc-v1.2.5-debug:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v2.0.4_runc-v1.2.5-debug_v0.2.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v2.0.4_runc-v1.2.5-debug:ctr_v0.2.0 | based on dqd `containerd-v2.0.4:ctr_v0.3.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v2.0.4_v0.2.0 | original nerdctl base |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v2.0.4_runc-v1.2.5-debug
$ ssh dqd-nerdctl-v2.0.4_runc-v1.2.5-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v2.0.4_runc-v1.2.5-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug ports

| Port | Component |
| ---- | --------- |
| 20406 | runc (dlv) |
| 20407 | runc init attach |

### Debug runc with nerdctl

```shell
root@nerdctl-2-0-4-runc-1-2-5-debug:~# ln -sf /root/runc.debug /usr/local/sbin/runc
root@nerdctl-2-0-4-runc-1-2-5-debug:~# runc --version
API server listening at: [::]:2346
2026-07-06T12:59:28Z warn layer=rpc Listening for remote connections (connections are not authenticated nor encrypted)
```

Use `attach.sh <pid>` to attach dlv to a running runc init process.

### Run a container with nerdctl

```shell
root@nerdctl-2-0-4-runc-1-2-5-debug:~# ln -sf /root/runc.real /usr/local/sbin/runc
root@nerdctl-2-0-4-runc-1-2-5-debug:~# nerdctl run hello-world

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

root@nerdctl-2-0-4-runc-1-2-5-debug:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-2-0-4-runc-1-2-5-debug:~# nerdctl build -t foo .
root@nerdctl-2-0-4-runc-1-2-5-debug:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED           PLATFORM       SIZE       BLOB SIZE
foo            latest    5ab06286eb59    12 seconds ago    linux/amd64    16.38kB    3.491kB
hello-world    latest    96498ffd522e    27 seconds ago    linux/amd64    16.38kB    4.015kB
```

### versions

```shell
root@nerdctl-2-0-4-runc-1-2-5-debug:~# ln -sf /root/runc.real /usr/local/sbin/runc
root@nerdctl-2-0-4-runc-1-2-5-debug:~# nerdctl --version
nerdctl version 2.0.4
root@nerdctl-2-0-4-runc-1-2-5-debug:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.20.2 97437fdd7e32f29bb80288d800cd4ffcb34e1c15
root@nerdctl-2-0-4-runc-1-2-5-debug:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.4 1a43cb6a1035441f9aca8f5666a9b3ef9e70ab20
root@nerdctl-2-0-4-runc-1-2-5-debug:~# runc --version
runc version 1.2.5
commit: v1.2.5-0-g59923ef1
spec: 1.2.0
go: go1.22.12
libseccomp: 2.5.5
root@nerdctl-2-0-4-runc-1-2-5-debug:~# cat /etc/os-release
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
root@nerdctl-2-0-4-runc-1-2-5-debug:~# uname -a
Linux nerdctl-2-0-4-runc-1-2-5-debug 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nerdctl/v2.0.4_runc-v1.2.5-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v2.0.4_runc-v1.2.5-debug:ctr_v0.2.0
```
