# docker v20.10.19

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v20.10.19:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v20.10.19:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v20.10.19_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v20.10.19:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v20.10.19_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v20.10.19
$ ssh dqd-docker-v20.10.19
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v20.10.19
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-20-10-19:~# docker run -i hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-20-10-19:~# docker version
<!-- VERIFY -->
root@docker-20-10-19:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-20-10-19:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v20.10.19
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v20.10.19:ctr_v0.1.0
```
