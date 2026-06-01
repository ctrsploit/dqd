# docker v28.0.4 CentOS Stream 9 runc debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9-runc-v1.2.5-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9-runc-v1.2.5-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v28.0.4-centos-stream9-runc-v1.2.5-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9-runc-v1.2.5-debug:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v28.0.4-centos-stream9-runc-v1.2.5-debug
$ ssh dqd-docker-v28.0.4-centos-stream9-runc-v1.2.5-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v28.0.4-centos-stream9-runc-v1.2.5-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug ports

| Port | Component |
|------|-----------|
| 28051 | runc (dlv) |
| 28052 | runc init attach |

### Run a container

```shell
[root@docker-28-0-4-centos-stream9 ~]# docker run -i hello-world
<!-- VERIFY -->
```

### versions

```shell
[root@docker-28-0-4-centos-stream9 ~]# docker version
<!-- VERIFY -->
[root@docker-28-0-4-centos-stream9 ~]# cat /etc/os-release
<!-- VERIFY -->
[root@docker-28-0-4-centos-stream9 ~]# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v28.0.4-centos-stream9-runc-v1.2.5-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9-runc-v1.2.5-debug:ctr_v0.1.0
```
