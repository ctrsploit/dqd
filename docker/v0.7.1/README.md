# docker v0.7.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v0.7.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v0.7.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v0.7.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v0.7.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v0.7.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v0.7.1
$ ssh dqd-docker-v0.7.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v0.7.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### versions

```shell
root@docker-0-7-1:~# docker --version
<!-- VERIFY -->
root@docker-0-7-1:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-0-7-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v0.7.1
```
