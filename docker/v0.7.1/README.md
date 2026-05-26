# docker v0.7.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v0.7.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v0.7.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v0.7.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v0.7.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v0.7.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v0.7.1
$ ssh dqd-docker-v0.7.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v0.7.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### versions

```shell
root@docker-0-7-1:~# docker --version
bash: docker: command not found
root@docker-0-7-1:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="12.04.5 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.5 LTS)"
VERSION_ID="12.04"
root@docker-0-7-1:~# uname -a
Linux docker-0-7-1 3.2.0-150-virtual #197-Ubuntu SMP Mon Apr 5 23:03:53 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v0.7.1
```
