# docker v19.03.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v19.03.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v19.03.1:v0.1.0 | first 19.03.x release with CVE-2019-14271 fixed, base of vul/cve-2019-14271-fix |
| ctr | ghcr.io/ctrsploit/docker-v19.03.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v19.03.1
$ ssh dqd-docker-v19.03.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v19.03.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-19-03-1:~# docker run -ti busybox:1.31.1 id
<!-- VERIFY -->
```

### versions

```shell
root@docker-19-03-1:~# docker version
<!-- VERIFY -->
root@docker-19-03-1:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-19-03-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v19.03.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v19.03.1:ctr_v0.1.0
```
