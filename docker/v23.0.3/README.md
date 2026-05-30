# docker v23.0.3

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v23.0.3:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v23.0.3:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v23.0.3_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v23.0.3:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v23.0.3_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v23.0.3
$ ssh dqd-docker-v23.0.3
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v23.0.3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-23-0-3:~# docker run -i hello-world
<<<<<<< HEAD
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
=======
<!-- VERIFY -->
>>>>>>> f5348b1b06ba3ec0e7c16282a3064e796b7681c0
```

### versions

```shell
root@docker-23-0-3:~# docker version
<<<<<<< HEAD
Client: Docker Engine - Community
 Version:           23.0.3
 API version:       1.42
 Go version:        go1.19.7
 Git commit:        3e7cbfd
 Built:             Tue Apr  4 22:05:48 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          23.0.3
  API version:      1.42 (minimum version 1.12)
  Go version:       go1.19.7
  Git commit:       59118bf
  Built:            Tue Apr  4 22:05:48 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.19
  GitCommit:        1e1ea6e986c6c86565bc33d52e34b81b3e2bc71f
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@docker-23-0-3:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@docker-23-0-3:~# uname -a
Linux docker-23-0-3 5.15.0-179-generic #189-Ubuntu SMP Tue May 5 18:20:56 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
=======
<!-- VERIFY -->
root@docker-23-0-3:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-23-0-3:~# uname -a
<!-- VERIFY -->
>>>>>>> f5348b1b06ba3ec0e7c16282a3064e796b7681c0
```

## build

```shell
make all ENV=docker/v23.0.3
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v23.0.3:ctr_v0.1.0
```
