# docker 29.7.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.7.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.7.1:v0.1.0 | docker 29.7.1 |
| ctr | ghcr.io/ctrsploit/docker-v29.7.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.7.1
$ ssh dqd-docker-v29.7.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.7.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Without kvm

```shell
$ docker compose -f docker-compose.yml up -d
```

### Run a container

```shell
root@docker-29-7-1:~# docker run --rm hello-world
<!-- VERIFY -->
```

## versions

```shell
root@docker-29-7-1:~# docker version
<!-- VERIFY -->
root@docker-29-7-1:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-29-7-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v29.7.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.7.1:ctr_v0.1.0
```
