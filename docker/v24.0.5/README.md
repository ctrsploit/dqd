# docker v24.0.5

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v24.0.5:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v24.0.5:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v24.0.5_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v24.0.5:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v24.0.5_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v24.0.5
$ ssh dqd-docker-v24.0.5
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v24.0.5
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-24-0-5:~# docker run -i hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-24-0-5:~# docker version
<!-- VERIFY -->
root@docker-24-0-5:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-24-0-5:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v24.0.5
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v24.0.5:ctr_v0.1.0
```
