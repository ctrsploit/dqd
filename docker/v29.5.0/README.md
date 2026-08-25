# docker v29.5.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.5.0:latest | points to `v0.1.1` |
| dqd | ghcr.io/ctrsploit/docker-v29.5.0:v0.1.1 | - |
| ctr | ghcr.io/ctrsploit/docker-v29.5.0:ctr_v0.1.1 | - |
| dqd | ghcr.io/ctrsploit/docker-v29.5.0:v0.1.0 | superseded: CI AppArmor workaround broke non-harbor builds |
| ctr | ghcr.io/ctrsploit/docker-v29.5.0:ctr_v0.1.0 | not published (build failed) |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.5.0
$ ssh dqd-docker-v29.5.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.5.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@docker-29-5-0:~# docker run -ti hello-world
<!-- VERIFY -->
```

```shell
root@docker-29-5-0:~# docker version
<!-- VERIFY -->
root@docker-29-5-0:~# containerd --version
<!-- VERIFY -->
root@docker-29-5-0:~# runc --version
<!-- VERIFY -->
root@docker-29-5-0:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-29-5-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v29.5.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.5.0:ctr_v0.1.1
```
