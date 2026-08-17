# docker v19.03.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v19.03.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v19.03.0:v0.1.0 | pre-19.03.1 release, target of vul/cve-2019-14271 |
| ctr | ghcr.io/ctrsploit/docker-v19.03.0:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v19.03.0
$ ssh dqd-docker-v19.03.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v19.03.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-19-03-0:~# docker run -ti ubuntu:18.04 id
<!-- VERIFY -->
```

### versions

```shell
root@docker-19-03-0:~# docker version
<!-- VERIFY -->
root@docker-19-03-0:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-19-03-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v19.03.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v19.03.0:ctr_v0.1.0
```
