# docker v29.9.2 Debian 13.7

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.9.2-debian-13.7:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.9.2-debian-13.7:v0.1.0 | Docker 29.9.2 on Debian 13.7 (trixie) |
| ctr | ghcr.io/ctrsploit/docker-v29.9.2-debian-13.7:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.9.2-debian-13.7
$ ssh dqd-docker-v29.9.2-debian-13.7
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.9.2-debian-13.7
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-29-9-2-debian-13-7:~# docker run -ti hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-29-9-2-debian-13-7:~# docker version
<!-- VERIFY -->
root@docker-29-9-2-debian-13-7:~# containerd --version
<!-- VERIFY -->
root@docker-29-9-2-debian-13-7:~# runc --version
<!-- VERIFY -->
root@docker-29-9-2-debian-13-7:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-29-9-2-debian-13-7:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v29.9.2-debian-13.7
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.9.2-debian-13.7:ctr_v0.1.0
```
