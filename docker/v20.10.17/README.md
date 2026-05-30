# docker v20.10.17

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v20.10.17:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v20.10.17:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v20.10.17_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v20.10.17:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v20.10.17_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v20.10.17
$ ssh dqd-docker-v20.10.17
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v20.10.17
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-20-10-17:~# docker run -ti hello-world
```

### versions

```shell
root@docker-20-10-17:~# docker version
<!-- VERIFY -->
root@docker-20-10-17:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-20-10-17:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v20.10.17
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v20.10.17:ctr_v0.1.0
```
