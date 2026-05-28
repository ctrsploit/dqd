# docker v1.0.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v1.0.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v1.0.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v1.0.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v1.0.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v1.0.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v1.0.1
$ ssh dqd-docker-v1.0.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v1.0.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-1-0-1:~# docker pull hello-world
Pulling repository hello-world
2026/05/28 08:53:32 HTTP code: 410
root@docker-1-0-1:~# docker run hello-world
Unable to find image 'hello-world' locally
Pulling repository hello-world
2026/05/28 08:53:43 HTTP code: 410
```

### versions

```shell
root@docker-1-0-1:~# docker --version
Docker version 1.0.1, build 990021a
root@docker-1-0-1:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
root@docker-1-0-1:~# uname -a
Linux docker-1-0-1 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v1.0.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v1.0.1:ctr_v0.1.0
```
