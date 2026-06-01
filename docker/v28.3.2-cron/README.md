# docker v28.3.2 cron

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v28.3.2-cron:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v28.3.2-cron:v0.1.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up docker/v28.3.2-cron
$ ssh dqd-docker-v28.3.2-cron
```

### Run a container

```shell
root@docker-28-3-2-cron:~# docker run -i hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-28-3-2-cron:~# docker version
<!-- VERIFY -->
root@docker-28-3-2-cron:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-28-3-2-cron:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v28.3.2-cron
```
