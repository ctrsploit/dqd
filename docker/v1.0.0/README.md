# docker v1.0.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v1.0.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v1.0.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v1.0.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v1.0.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v1.0.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v1.0.0
$ ssh dqd-docker-v1.0.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v1.0.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-1-0-0:~# docker import https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz alpine
Downloading from https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz
cf0def934523fcaab56d985cba390d8d9f12141ef093977d3be24ccbfcdbbadb
root@docker-1-0-0:~# docker run -i alpine echo hello
hello
root@docker-1-0-0:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                              PORTS               NAMES
fde8db9fd46d        alpine:latest       echo hello          1 seconds ago       Exited (0) Less than a second ago                       lonely_hypatia
```

### versions

```shell
root@docker-1-0-0:~# docker --version
Docker version 1.0.0, build 63fe64c
root@docker-1-0-0:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
root@docker-1-0-0:~# uname -a
Linux docker-1-0-0 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v1.0.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v1.0.0:ctr_v0.1.0
```
