# docker v29.4.1 Debian

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.4.1-debian:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.4.1-debian:v0.1.0 | dynamic linked runc |
| ctr | ghcr.io/ctrsploit/docker-v29.4.1-debian:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.4.1-debian
$ ssh dqd-docker-v29.4.1-debian
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.4.1-debian
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-29-4-1-debian:~# docker run -ti hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pull complete
d5e71e642bf5: Download complete
Digest: sha256:96498ffd522e70807ab6384a5c0485a79b9c7c08ca79ba08623edcad1054e62d
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### versions

```shell
root@docker-29-4-1-debian:~# docker version
Client: Docker Engine - Community
 Version:           29.4.1
 API version:       1.54
 Go version:        go1.26.2
 Git commit:        055a478
 Built:             Mon Apr 20 16:32:41 2026
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          29.4.1
  API version:      1.54 (minimum version 1.40)
  Go version:       go1.26.2
  Git commit:       6c91b92
  Built:            Mon Apr 20 16:32:41 2026
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          v2.2.3
  GitCommit:        77c84241c7cbdd9b4eca2591793e3d4f4317c590
 runc:
  Version:          1.3.5
  GitCommit:        v1.3.5-0-g488fc13e
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@docker-29-4-1-debian:~# containerd --version
containerd containerd.io v2.2.3 77c84241c7cbdd9b4eca2591793e3d4f4317c590
root@docker-29-4-1-debian:~# runc --version
runc version 1.3.5
commit: v1.3.5-0-g488fc13e
spec: 1.2.1
go: go1.25.9
libseccomp: 2.5.4
root@docker-29-4-1-debian:~# cat /etc/os-release 
PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
NAME="Debian GNU/Linux"
VERSION_ID="12"
VERSION="12 (bookworm)"
VERSION_CODENAME=bookworm
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
root@docker-29-4-1-debian:~# uname -a
Linux docker-29-4-1-debian 6.1.0-49-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.174-1 (2026-05-26) x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v29.4.1-debian
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.4.1-debian:ctr_v0.1.0
```
