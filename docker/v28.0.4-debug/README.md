# docker v28.0.4 debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v28.0.4-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v28.0.4-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v28.0.4-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v28.0.4-debug:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v28.0.4-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v28.0.4-debug
$ ssh dqd-docker-v28.0.4-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v28.0.4-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug ports

| Port | Component |
|------|-----------|
| 28045 | dockerd (dlv) |
| 28046 | runc (dlv) |
| 28047 | runc init attach |

### Run a container

```shell
root@docker-28-0-4-debug:~# docker run -i hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-28-0-4-debug:~# docker version
<!-- VERIFY -->
root@docker-28-0-4-debug:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-28-0-4-debug:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v28.0.4-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v28.0.4-debug:ctr_v0.1.0
```
