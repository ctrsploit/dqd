# docker v0.7.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v0.7.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v0.7.2:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v0.7.2_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v0.7.2:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v0.7.2_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v0.7.2
$ ssh dqd-docker-v0.7.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v0.7.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-0-7-2:~# docker import https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz alpine
9496128158d932f0d8c5282ec648229a88660f27355dadb758d6bd8363b57f8c
root@docker-0-7-2:~# docker run -i alpine echo hello
hello
root@docker-0-7-2:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED                  STATUS              PORTS               NAMES
b9d884fcce95        alpine:latest       echo hello          Less than a second ago   Exit 0                                  hungry_mclean
```

### versions

```shell
root@docker-0-7-2:~# docker version
Client version: 0.7.2
Go version (client): go1.2
Git commit (client): 28b162e
Server version: 0.7.2
Git commit (server): 28b162e
Go version (server): go1.2
Last stable version: 17.05.0-ce, please update docker
root@docker-0-7-2:~# lxc-version
lxc version: 0.7.5
root@docker-0-7-2:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="12.04.5 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.5 LTS)"
VERSION_ID="12.04"
root@docker-0-7-2:~# uname -a
Linux docker-0-7-2 3.2.0-150-virtual #197-Ubuntu SMP Mon Apr 5 23:03:53 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v0.7.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v0.7.2:ctr_v0.1.0
```
