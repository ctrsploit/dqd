# docker v0.9.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v0.9.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v0.9.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v0.9.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v0.9.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v0.9.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v0.9.0
$ ssh dqd-docker-v0.9.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v0.9.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-0-9-0:~# docker import https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz alpine
ee6887459579e72e0d1063ffd6e24aab409633e0ca874934ba4347a77174d173
root@docker-0-9-0:~# docker run -i alpine echo hello
hello
root@docker-0-9-0:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
ca352ecd144f        alpine:latest       echo hello          1 seconds ago       Exit 0                                  angry_heisenberg
```

### versions

```shell
root@docker-0-9-0:~# docker version
Client version: 0.9.0
Go version (client): go1.2.1
Git commit (client): 2b3fdf2
Server version: 0.9.0
Git commit (server): 2b3fdf2
Go version (server): go1.2.1
Last stable version: 17.05.0-ce, please update docker
root@docker-0-9-0:~# lxc-version
lxc version: 0.7.5
root@docker-0-9-0:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="12.04.5 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.5 LTS)"
VERSION_ID="12.04"
root@docker-0-9-0:~# uname -a
Linux docker-0-9-0 3.2.0-150-virtual #197-Ubuntu SMP Mon Apr 5 23:03:53 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v0.9.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v0.9.0:ctr_v0.1.0
```
