# docker v0.11.1 lxc

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v0.11.1-lxc:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v0.11.1-lxc:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v0.11.1-lxc_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v0.11.1-lxc:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v0.11.1-lxc_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v0.11.1-lxc
$ ssh dqd-docker-v0.11.1-lxc
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v0.11.1-lxc
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-0-11-1-lxc:~# docker import https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz alpine
2a9d93b3211edeaf4f8f3d0cf3f6ea15ac50ab1112830c5fa49233e69947ea9b
root@docker-0-11-1-lxc:~# docker run -i alpine echo hello
hello
root@docker-0-11-1-lxc:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED                  STATUS                              PORTS               NAMES
99223aa5053a        alpine:latest       echo hello          Less than a second ago   Exited (0) Less than a second ago                       suspicious_euclid
```

### versions

```shell
root@docker-0-11-1-lxc:~# docker version
Client version: 0.11.1
Client API version: 1.11
Go version (client): go1.2.1
Git commit (client): fb99f99
Server version: 0.11.1
Server API version: 1.11
Git commit (server): fb99f99
Go version (server): go1.2.1
Last stable version: 17.05.0-ce, please update docker
root@docker-0-11-1-lxc:~# lxc-start --version
1.0.10
root@docker-0-11-1-lxc:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
root@docker-0-11-1-lxc:~# uname -a
Linux docker-0-11-1-lxc 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v0.11.1-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v0.11.1-lxc:ctr_v0.1.0
```
