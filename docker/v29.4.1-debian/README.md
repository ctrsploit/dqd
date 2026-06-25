# docker v29.4.1 Debian

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.4.1-debian:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.4.1-debian:v0.1.0 | dynamic linked runc |
| ctr | ghcr.io/ctrsploit/docker-v29.4.1-debian:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.4.1-debian
$ ssh dqd-docker-v29.4.1-debian
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.4.1-debian
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-29-4-1-debian:~# docker run -ti hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-29-4-1-debian:~# docker version
<!-- VERIFY -->
root@docker-29-4-1-debian:~# containerd --version
<!-- VERIFY -->
root@docker-29-4-1-debian:~# runc --version
<!-- VERIFY -->
root@docker-29-4-1-debian:~# cat /etc/os-release 
<!-- VERIFY -->
root@docker-29-4-1-debian:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v29.4.1-debian
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.4.1-debian:ctr_v0.1.0
```
