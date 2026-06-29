# nerdctl v0.15.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v0.15.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v0.15.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v0.15.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v0.15.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v0.15.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v0.15.0
$ ssh dqd-nerdctl-v0.15.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v0.15.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-0-15-0:~# nerdctl run --security-opt apparmor=unconfined hello-world

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

root@nerdctl-0-15-0:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-0-15-0:~# nerdctl build -t foo .
root@nerdctl-0-15-0:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED                   PLATFORM       SIZE
foo            latest    026e7c57188e    Less than a second ago    linux/amd64    16.0 KiB
hello-world    latest    96498ffd522e    16 seconds ago            linux/amd64    16.0 KiB
hello-world    latest    96498ffd522e    16 seconds ago            linux/386      0.0 B
```

### versions

```shell
root@nerdctl-0-15-0:~# nerdctl --version
nerdctl version 0.15.0
root@nerdctl-0-15-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.9.3 8d2625494a6a3d413e3d875a2ff7dd9b1ed1b1a9
root@nerdctl-0-15-0:~# containerd --version
containerd github.com/containerd/containerd v1.5.8 1e5ef943eb76627a6d3b6de8cd1ef6537f393a71
root@nerdctl-0-15-0:~# runc --version
runc version 1.0.2
commit: v1.0.2-0-g52b36a2dd837
spec: 1.0.2-dev
go: go1.16.7
libseccomp: 2.5.1
root@nerdctl-0-15-0:~# cat /etc/os-release
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
root@nerdctl-0-15-0:~# uname -a
Linux nerdctl-0-15-0 6.8.0-124-generic #124-Ubuntu SMP PREEMPT_DYNAMIC Tue May 26 13:00:45 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nerdctl/v0.15.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v0.15.0:ctr_v0.1.0
```

## Known Issue

### apparmor_parser

https://github.com/containerd/nerdctl/issues/3945

```
root@nerdctl-0-15-0:~# nerdctl run hello-world
time="2026-06-29T07:56:16Z" level=fatal msg="get apparmor_parser version: exec: \"apparmor_parser\": executable file not found in $PATH"
```
