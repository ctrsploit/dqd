# docker v19.03.13

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v19.03.13:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v19.03.13:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v19.03.13_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v19.03.13:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v19.03.13_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v19.03.13
$ ssh dqd-docker-v19.03.13
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v19.03.13
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-19-03-13:~# docker run -ti ubuntu:20.04 id
uid=0(root) gid=0(root) groups=0(root)
```

### versions

```shell
root@docker-19-03-13:~# docker version
<!-- VERIFY -->
root@docker-19-03-13:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-19-03-13:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v19.03.13
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v19.03.13:ctr_v0.1.0
```
