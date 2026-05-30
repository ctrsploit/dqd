# docker v23.0.0 devicemapper

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v23.0.0-devicemapper:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v23.0.0-devicemapper:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v23.0.0-devicemapper_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v23.0.0-devicemapper:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v23.0.0-devicemapper_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v23.0.0-devicemapper
$ ssh dqd-docker-v23.0.0-devicemapper
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v23.0.0-devicemapper
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-23-0-0-devicemapper:~# docker run -i hello-world
<!-- VERIFY -->
```

### Storage driver

```shell
root@docker-23-0-0-devicemapper:~# docker info
<!-- VERIFY -->
```

### versions

```shell
root@docker-23-0-0-devicemapper:~# docker version
<!-- VERIFY -->
root@docker-23-0-0-devicemapper:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-23-0-0-devicemapper:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v23.0.0-devicemapper
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v23.0.0-devicemapper:ctr_v0.1.0
```
