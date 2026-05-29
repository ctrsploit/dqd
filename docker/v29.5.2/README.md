# docker v29.5.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.5.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.5.2:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v29.5.2:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.5.2
$ ssh dqd-docker-v29.5.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.5.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@docker-29-5-2:~# docker run -ti hello-world
<!-- VERIFY -->
```

```shell
root@docker-29-5-2:~# docker version
<!-- VERIFY -->
root@docker-29-5-2:~# containerd --version
<!-- VERIFY -->
root@docker-29-5-2:~# runc --version
<!-- VERIFY -->
root@docker-29-5-2:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-29-5-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v29.5.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.5.2:ctr_v0.1.0
```
