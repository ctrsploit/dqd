# docker v17.06.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v17.06.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v17.06.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v17.06.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v17.06.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v17.06.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v17.06.0
$ ssh dqd-docker-v17.06.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v17.06.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-17-06-0:~# docker run -ti ubuntu:16.04 id
uid=0(root) gid=0(root) groups=0(root)
```

### versions

```shell
root@docker-17-06-0:~# docker version
<!-- VERIFY -->
root@docker-17-06-0:~# docker-containerd --version
<!-- VERIFY -->
root@docker-17-06-0:~# docker-runc --version
<!-- VERIFY -->
root@docker-17-06-0:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-17-06-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v17.06.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v17.06.0:ctr_v0.1.0
```
