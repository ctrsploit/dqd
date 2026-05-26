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
root@docker-0-7-2:~# docker pull ubuntu:12.04
<!-- VERIFY -->
root@docker-0-7-2:~# docker run -it ubuntu:12.04 /bin/bash
<!-- VERIFY -->
root@docker-0-7-2:~# docker ps -a
<!-- VERIFY -->
```

### versions

```shell
root@docker-0-7-2:~# docker version
<!-- VERIFY -->
root@docker-0-7-2:~# lxc-version
<!-- VERIFY -->
root@docker-0-7-2:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-0-7-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v0.7.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v0.7.2:ctr_v0.1.0
```
