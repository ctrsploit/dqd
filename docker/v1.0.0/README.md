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
<!-- VERIFY -->
root@docker-1-0-0:~# docker run -i alpine echo hello
<!-- VERIFY -->
```

### versions

```shell
root@docker-1-0-0:~# docker --version
<!-- VERIFY -->
root@docker-1-0-0:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-1-0-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v1.0.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v1.0.0:ctr_v0.1.0
```
