# docker-compose v2.40.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-compose-v2.40.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-compose-v2.40.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-compose-v2.40.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-compose-v2.40.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-compose-v2.40.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker-compose/v2.40.1
$ ssh dqd-docker-compose-v2.40.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker-compose/v2.40.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### docker compose

```shell
root@docker-compose-2-40-1:~# docker compose version
<!-- VERIFY -->
```

### versions

```shell
root@docker-compose-2-40-1:~# docker --version
<!-- VERIFY -->
root@docker-compose-2-40-1:~# containerd --version
<!-- VERIFY -->
root@docker-compose-2-40-1:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-compose-2-40-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker-compose/v2.40.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-compose-v2.40.1:ctr_v0.1.0
```
