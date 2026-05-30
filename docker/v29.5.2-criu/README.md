# docker v29.5.2 with criu

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.5.2-criu:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.5.2-criu:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v29.5.2-criu:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.5.2-criu
$ ssh dqd-docker-v29.5.2-criu
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.5.2-criu
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with checkpoint/restore

```shell
root@docker-29-5-2-criu:~# docker run -d --name test alpine sleep 60
<!-- VERIFY -->
root@docker-29-5-2-criu:~# docker checkpoint create test checkpoint1
<!-- VERIFY -->
root@docker-29-5-2-criu:~# docker checkpoint ls test
<!-- VERIFY -->
root@docker-29-5-2-criu:~# docker start --checkpoint checkpoint1 test
<!-- VERIFY -->
```

### versions

```shell
root@docker-29-5-2-criu:~# docker version
<!-- VERIFY -->
root@docker-29-5-2-criu:~# criu --version
<!-- VERIFY -->
root@docker-29-5-2-criu:~# containerd --version
<!-- VERIFY -->
root@docker-29-5-2-criu:~# runc --version
<!-- VERIFY -->
root@docker-29-5-2-criu:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-29-5-2-criu:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v29.5.2-criu
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.5.2-criu:ctr_v0.1.0
```
