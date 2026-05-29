# docker v1.12.2-rc3

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v1.12.2-rc3:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v1.12.2-rc3:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v1.12.2-rc3_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v1.12.2-rc3:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v1.12.2-rc3_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v1.12.2-rc3
$ ssh dqd-docker-v1.12.2-rc3
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v1.12.2-rc3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-1-12-2-rc3:~# docker run -i ubuntu:16.04 id
Unable to find image 'ubuntu:16.04' locally
16.04: Pulling from library/ubuntu
58690f9b18fc: Pulling fs layer
b51569e7c507: Pulling fs layer
da8ef40b9eca: Pulling fs layer
fb15d46c38dc: Pulling fs layer
b51569e7c507: Verifying Checksum
b51569e7c507: Download complete
da8ef40b9eca: Verifying Checksum
da8ef40b9eca: Download complete
fb15d46c38dc: Verifying Checksum
fb15d46c38dc: Download complete
58690f9b18fc: Verifying Checksum
58690f9b18fc: Download complete
58690f9b18fc: Pull complete
b51569e7c507: Pull complete
da8ef40b9eca: Pull complete
fb15d46c38dc: Pull complete
Digest: sha256:1f1a2d56de1d604801a9671f301190704c25d604a416f59e03c04f5c6ffee0d6
Status: Downloaded newer image for ubuntu:16.04
uid=0(root) gid=0(root) groups=0(root)
```

### versions

```shell
root@docker-1-12-2-rc3:~# docker --version
Docker version 1.12.2-rc3, build cb0ca64
root@docker-1-12-2-rc3:~# docker-containerd --version
containerd version 0.2.4 commit: 0366d7e9693c930cf18c0f50cc16acec064e96c5
root@docker-1-12-2-rc3:~# docker-runc --version
runc version 1.0.0-rc2
commit: 02f8fa7863dd3f82909a73e2061897828460d52f
spec: 1.0.0-rc2-dev
root@docker-1-12-2-rc3:~# cat /etc/os-release
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
root@docker-1-12-2-rc3:~# uname -a
Linux docker-1-12-2-rc3 4.4.0-210-generic #242-Ubuntu SMP Fri Apr 16 09:57:56 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v1.12.2-rc3
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v1.12.2-rc3:ctr_v0.1.0
```
