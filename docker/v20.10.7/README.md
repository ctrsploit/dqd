# docker v20.10.7

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v20.10.7:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v20.10.7:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v20.10.7:ctr_v0.1.0 | bundles runc v1.0.0-rc95 (fixes CVE-2021-30465) |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v20.10.7
$ ssh dqd-docker-v20.10.7
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v20.10.7
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-20-10-7:~# docker run --rm busybox echo it-works
<!-- VERIFY -->
```

### versions

```shell
root@docker-20-10-7:~# docker version
<!-- VERIFY -->
root@docker-20-10-7:~# runc --version
<!-- VERIFY -->
root@docker-20-10-7:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-20-10-7:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v20.10.7
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v20.10.7:ctr_v0.1.0
```
