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
<!-- VERIFY -->
root@docker-1-0-0-lxc:~# docker run -i alpine echo hello
<!-- VERIFY -->
```

### versions

```shell
root@docker-1-0-0-lxc:~# docker --version
<!-- VERIFY -->
root@docker-1-0-0-lxc:~# ps aux | grep docker
<!-- VERIFY -->
root@docker-1-0-0-lxc:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-1-0-0-lxc:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v1.0.0-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v1.0.0-lxc:ctr_v0.1.0
```
