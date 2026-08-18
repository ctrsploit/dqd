# docker 29.7.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.7.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.7.0:v0.1.0 | docker 29.7.0 |
| ctr | ghcr.io/ctrsploit/docker-v29.7.0:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.7.0
$ ssh dqd-docker-v29.7.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.7.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Without kvm

```shell
$ docker compose -f docker-compose.yml up -d
```

### Run a container

```shell
root@docker-29-7-0:~# docker run --rm hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pulling fs layer
d5e71e642bf5: Download complete
4f55086f7dd0: Download complete
4f55086f7dd0: Pull complete
Digest: sha256:5dd0d3e6e255913fc30f90b9f2b1d359cc2cbdb48090cc4b65f1676e203243cc
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

## versions

```shell
root@docker-29-7-0:~# docker version
Client: Docker Engine - Community
 Version:           29.7.0
 API version:       1.55
 Go version:        go1.26.5
 Git commit:        c1eba93
 Built:             Thu Jul 30 20:20:28 2026
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          29.7.0
  API version:      1.55 (minimum version 1.40)
  Go version:       go1.26.5
  Git commit:       4b5cb71
  Built:            Thu Jul 30 20:20:28 2026
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
root@docker-29-7-0:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@docker-29-7-0:~# uname -a
Linux docker-29-7-0 6.8.0-138-generic #138-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 31 22:41:49 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v29.7.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.7.0:ctr_v0.1.0
```
