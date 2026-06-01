# docker v28.0.4 CentOS Stream 9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v28.0.4-centos-stream9_v0.2.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v28.0.4-centos-stream9_v0.2.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v28.0.4-centos-stream9
$ ssh dqd-docker-v28.0.4-centos-stream9
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v28.0.4-centos-stream9
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

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
make all ENV=docker/v28.0.4-centos-stream9
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9:ctr_v0.2.0
```
