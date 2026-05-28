# docker v1.0.0 lxc

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v1.0.0-lxc:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v1.0.0-lxc:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v1.0.0-lxc_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v1.0.0-lxc:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v1.0.0-lxc_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v1.0.0-lxc
$ ssh dqd-docker-v1.0.0-lxc
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v1.0.0-lxc
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with lxc

```shell
root@docker-1-0-0-lxc:~# docker import https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz alpine
Downloading from https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz
36cfc1bbd19a615ba5e9a2be9744740fa344a1b45e1e7a6bc16d7f8eb49f20b5
root@docker-1-0-0-lxc:~# docker run -i alpine echo hello
hello
root@docker-1-0-0-lxc:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                              PORTS               NAMES
c7738bde7c5d        alpine:latest       echo hello          1 seconds ago       Exited (0) Less than a second ago                       clever_darwin
```

### versions

```shell
root@docker-1-0-0-lxc:~# docker --version
Docker version 1.0.0, build 63fe64c
root@docker-1-0-0-lxc:~# ps aux | grep docker
root       594  3.5  0.7 368116 15656 ?        Ssl  07:22   0:00 /usr/bin/docker -d -e lxc
root@docker-1-0-0-lxc:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
root@docker-1-0-0-lxc:~# uname -a
Linux docker-1-0-0-lxc 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v1.0.0-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v1.0.0-lxc:ctr_v0.1.0
```
