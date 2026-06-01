# docker v28.2.2 containerd v2.1.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v28.2.2-containerd-v2.1.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v28.2.2-containerd-v2.1.0:v0.1.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up docker/v28.2.2-containerd-v2.1.0
$ ssh dqd-docker-v28.2.2-containerd-v2.1.0
```

### Run a container

```shell
root@docker-28-2-2-containerd-2-1-0:~# docker run -i hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-28-2-2-containerd-2-1-0:~# docker version
<!-- VERIFY -->
root@docker-28-2-2-containerd-2-1-0:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-28-2-2-containerd-2-1-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v28.2.2-containerd-v2.1.0
```
