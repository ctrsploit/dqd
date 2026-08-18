# docker 29.6.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.6.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.6.2:v0.1.0 | docker 29.6.2 |
| ctr | ghcr.io/ctrsploit/docker-v29.6.2:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.6.2
$ ssh dqd-docker-v29.6.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.6.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Without kvm

```shell
$ docker compose -f docker-compose.yml up -d
```

### Run a container

```shell
root@docker-29-6-2:~# docker run --rm hello-world

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
root@docker-29-6-2:~# docker version
Client: Docker Engine - Community
 Version:           29.6.2
 API version:       1.55
 Go version:        go1.26.5
 Git commit:        dfc4efb
 Built:             Thu Jul 16 16:12:18 2026
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          29.6.2
  API version:      1.55 (minimum version 1.40)
  Go version:       go1.26.5
  Git commit:       3d80467
  Built:            Thu Jul 16 16:12:18 2026
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
root@docker-29-6-2:~# cat /etc/os-release
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
root@docker-29-6-2:~# uname -a
Linux docker-29-6-2 6.8.0-138-generic #138-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 31 22:41:49 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v29.6.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.6.2:ctr_v0.1.0
```
