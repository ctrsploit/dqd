# docker v17.06.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v17.06.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v17.06.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v17.06.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v17.06.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v17.06.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v17.06.0
$ ssh dqd-docker-v17.06.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v17.06.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-17-06-0:~# docker run -ti ubuntu:16.04 id
uid=0(root) gid=0(root) groups=0(root)
```

### versions

```shell
root@docker-17-06-0:~# docker version
Client:
 Version:      17.06.0-ce
 API version:  1.30
 Go version:   go1.8.3
 Git commit:   02c1d87
 Built:        Fri Jun 23 21:23:31 2017
 OS/Arch:      linux/amd64

Server:
 Version:      17.06.0-ce
 API version:  1.30 (minimum version 1.12)
 Go version:   go1.8.3
 Git commit:   02c1d87
 Built:        Fri Jun 23 21:19:04 2017
 OS/Arch:      linux/amd64
 Experimental: false
root@docker-17-06-0:~# docker-containerd --version
containerd version 0.2.3 commit: cfb82a876ecc11b5ca0977d1733adbe58599088a
root@docker-17-06-0:~# docker-runc --version
runc version 1.0.0-rc3
commit: 2d41c047c83e09a6d61d464906feb2a2f3c52aa4
spec: 1.0.0-rc5
root@docker-17-06-0:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.7 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.7 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
root@docker-17-06-0:~# uname -a
Linux docker-17-06-0 4.4.0-210-generic #242-Ubuntu SMP Fri Apr 16 09:57:56 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v17.06.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v17.06.0:ctr_v0.1.0
```
