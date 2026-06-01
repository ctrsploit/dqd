# docker v28.0.4 CentOS Stream 9 runc debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9-runc-v1.2.5-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9-runc-v1.2.5-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v28.0.4-centos-stream9-runc-v1.2.5-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9-runc-v1.2.5-debug:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v28.0.4-centos-stream9-runc-v1.2.5-debug
$ ssh dqd-docker-v28.0.4-centos-stream9-runc-v1.2.5-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v28.0.4-centos-stream9-runc-v1.2.5-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug ports

| Port | Component |
|------|-----------|
| 28051 | runc (dlv) |
| 28052 | runc init attach |

### Run a container

```shell
[root@docker-28-0-4-centos-stream9 ~]# docker run -i hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pulling fs layer
4f55086f7dd0: Verifying Checksum
4f55086f7dd0: Download complete
4f55086f7dd0: Pull complete
Digest: sha256:0e760fdfbc48ba8041e7c6db999bb40bfca508b4be580ac75d32c4e29d202ce1
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
[root@docker-28-0-4-centos-stream9 ~]# docker version
Client: Docker Engine - Community
 Version:           28.0.4
 API version:       1.48
 Go version:        go1.23.7
 Git commit:        b8034c0
 Built:             Tue Mar 25 15:08:34 2025
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          28.0.4
  API version:      1.48 (minimum version 1.24)
  Go version:       go1.23.7
  Git commit:       6430e49
  Built:            Tue Mar 25 15:06:50 2025
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.7.27
  GitCommit:        05044ec0a9a75232cad458027ca83437aae3f4da
 runc:
  Version:          1.2.5
  GitCommit:        v1.2.5-0-g59923ef
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
[root@docker-28-0-4-centos-stream9 ~]# cat /etc/os-release
NAME="CentOS Stream"
VERSION="9"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="9"
PLATFORM_ID="platform:el9"
PRETTY_NAME="CentOS Stream 9"
ANSI_COLOR="0;31"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:centos:centos:9"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://issues.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 9"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
[root@docker-28-0-4-centos-stream9 ~]# uname -a
Linux docker-28-0-4-centos-stream9 5.14.0-708.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Wed May 20 09:11:55 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v28.0.4-centos-stream9-runc-v1.2.5-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v28.0.4-centos-stream9-runc-v1.2.5-debug:ctr_v0.1.0
```
