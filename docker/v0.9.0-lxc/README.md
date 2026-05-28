# docker v0.9.0 lxc

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v0.9.0-lxc:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v0.9.0-lxc:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v0.9.0-lxc_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v0.9.0-lxc:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v0.9.0-lxc_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v0.9.0-lxc
$ ssh dqd-docker-v0.9.0-lxc
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v0.9.0-lxc
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with lxc

```shell
root@docker-0-9-0-lxc:~# docker import https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz alpine
Downloading from https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz

b884bee656351d9b1ca5c161f9025b976a8c0dfeb999e7f8092750b5b7327fdd
root@docker-0-9-0-lxc:~# docker run -i alpine echo hello
hello
root@docker-0-9-0-lxc:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED                  STATUS              PORTS               NAMES
f48172f98203        alpine:latest       echo hello          Less than a second ago   Exit 0                                  boring_pare
```

### versions

```shell
root@docker-0-9-0-lxc:~# docker --version
Docker version 0.9.0, build 2b3fdf2
root@docker-0-9-0-lxc:~# ps aux | grep docker
root       367  0.2  0.3 469708  7156 ?        Sl   06:34   0:00 /usr/bin/docker -d -e lxc
root@docker-0-9-0-lxc:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="12.04.5 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.5 LTS)"
VERSION_ID="12.04"
root@docker-0-9-0-lxc:~# uname -a
Linux docker-0-9-0-lxc 3.2.0-150-virtual #197-Ubuntu SMP Mon Apr 5 23:03:53 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v0.9.0-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v0.9.0-lxc:ctr_v0.1.0
```
