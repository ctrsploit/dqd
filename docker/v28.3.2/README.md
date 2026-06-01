# docker v28.3.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v28.3.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v28.3.2:v0.1.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up docker/v28.3.2
$ ssh dqd-docker-v28.3.2
```

### Run a container

```shell
root@docker-28-3-2:~# docker run -i hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-28-3-2:~# docker version
<!-- VERIFY -->
root@docker-28-3-2:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-28-3-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v28.3.2
```
