# docker v1.12.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v1.12.4:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v1.12.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v1.12.4_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v1.12.4:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v1.12.4_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v1.12.4
$ ssh dqd-docker-v1.12.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v1.12.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-1-12-4:~# docker run -i ubuntu:16.04 id
<!-- VERIFY -->
```

### versions

```shell
root@docker-1-12-4:~# docker --version
<!-- VERIFY -->
root@docker-1-12-4:~# docker-containerd --version
<!-- VERIFY -->
root@docker-1-12-4:~# docker-runc --version
<!-- VERIFY -->
root@docker-1-12-4:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-1-12-4:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v1.12.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v1.12.4:ctr_v0.1.0
```
