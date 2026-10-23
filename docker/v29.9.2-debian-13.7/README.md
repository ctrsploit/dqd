# docker v29.9.2 Debian 13.7

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.9.2-debian-13.7:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.9.2-debian-13.7:v0.1.0 | Docker 29.9.2 on Debian 13.7 (trixie) |
| ctr | ghcr.io/ctrsploit/docker-v29.9.2-debian-13.7:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.9.2-debian-13.7
$ ssh dqd-docker-v29.9.2-debian-13.7
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.9.2-debian-13.7
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-29-9-2-debian-13-7:~# docker run -ti hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pulling fs layer
4f55086f7dd0: Download complete
4f55086f7dd0: Pull complete
d5e71e642bf5: Download complete
Digest: sha256:11a3eb1597e864c51b3f56733cb2e8a90bf0c284bfc05f9444d81c558bc848aa
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
root@docker-29-9-2-debian-13-7:~# docker version
Client: Docker Engine - Community
 Version:           29.9.2
 API version:       1.56
 Go version:        go1.26.10
 Git commit:        a82e528
 Built:             Tue Oct 20 18:45:13 2026
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          29.9.2
  API version:      1.56 (minimum version 1.40)
  Go version:       go1.26.10
  Git commit:       0367cbe
  Built:            Tue Oct 20 18:45:13 2026
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          v2.4.2
  GitCommit:        b7a25261e029d68978bbf290df0a62fc819b3c51
 runc:
  Version:          1.5.2
  GitCommit:        v1.5.2-0-g29dd3dc2
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@docker-29-9-2-debian-13-7:~# containerd --version
containerd containerd v2.4.2 b7a25261e029d68978bbf290df0a62fc819b3c51
root@docker-29-9-2-debian-13-7:~# runc --version
runc version 1.5.2
commit: v1.5.2-0-g29dd3dc2
spec: 1.3.0
go: go1.27.3
libseccomp: 2.6.0
root@docker-29-9-2-debian-13-7:~# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.7
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
root@docker-29-9-2-debian-13-7:~# uname -a
Linux docker-29-9-2-debian-13-7 6.12.113+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.113-1 (2026-10-15) x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v29.9.2-debian-13.7
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.9.2-debian-13.7:ctr_v0.1.0
```
