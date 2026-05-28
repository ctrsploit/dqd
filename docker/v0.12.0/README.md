# docker v0.12.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v0.12.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v0.12.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v0.12.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v0.12.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v0.12.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v0.12.0
$ ssh dqd-docker-v0.12.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v0.12.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-0-12-0:~# docker import https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz alpine
Downloading from https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz
a99302d741c8ddee643fa9012d963b5b1211df6fb91512787e3c48994cd1c3e4
root@docker-0-12-0:~# docker run -i alpine echo hello
hello
root@docker-0-12-0:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED                  STATUS                              PORTS               NAMES
0f173bd9a93b        alpine:latest       echo hello          Less than a second ago   Exited (0) Less than a second ago                       dreamy_rosalind
```

### versions

```shell
root@docker-0-12-0:~# docker --version
Docker version 0.12.0, build 14680bf
root@docker-0-12-0:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
root@docker-0-12-0:~# uname -a
Linux docker-0-12-0 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v0.12.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v0.12.0:ctr_v0.1.0
```
