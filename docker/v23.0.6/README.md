# docker v23.0.6

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v23.0.6:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v23.0.6:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ubuntu-22.04_docker-v23.0.6_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v23.0.6:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-22.04_docker-v23.0.6_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v23.0.6
$ ssh dqd-docker-v23.0.6
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v23.0.6
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-23-0-6:~# docker run -i hello-world
<!-- VERIFY -->
```

### versions

```shell
root@docker-23-0-6:~# docker version
<!-- VERIFY -->
root@docker-23-0-6:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-23-0-6:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v23.0.6
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v23.0.6:ctr_v0.1.0
```
