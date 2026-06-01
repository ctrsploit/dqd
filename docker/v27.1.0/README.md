# docker v27.1.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v27.1.0:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/docker-v27.1.0:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v27.1.0_v0.2.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v27.1.0:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v27.1.0_v0.2.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v27.1.0
$ ssh dqd-docker-v27.1.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v27.1.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-27-1-0:~# docker run -i hello-world
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
root@docker-27-1-0:~# docker version
Client: Docker Engine - Community
 Version:           27.1.0
 API version:       1.46
 Go version:        go1.21.12
 Git commit:        6312585
 Built:             Fri Jul 19 17:42:42 2024
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          27.1.0
  API version:      1.46 (minimum version 1.24)
  Go version:       go1.21.12
  Git commit:       a21b1a2
  Built:            Fri Jul 19 17:42:42 2024
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.7.20
  GitCommit:        8fc6bcff51318944179630522a095cc9dbf9f353
 runc:
  Version:          1.1.13
  GitCommit:        v1.1.13-0-g58aa920
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@docker-27-1-0:~# cat /etc/os-release
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
root@docker-27-1-0:~# uname -a
Linux docker-27-1-0 6.8.0-124-generic #124-Ubuntu SMP PREEMPT_DYNAMIC Tue May 26 13:00:45 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v27.1.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v27.1.0:ctr_v0.2.0
```
