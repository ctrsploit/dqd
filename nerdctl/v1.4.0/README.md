# nerdctl v1.4.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.4.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.4.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v1.4.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v1.4.0:ctr_v0.1.0 | based on dqd `containerd-v1.7.1:ctr_v0.1.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v1.4.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v1.4.0
$ ssh dqd-nerdctl-v1.4.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v1.4.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-1-4-0:~# nerdctl run hello-world

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
root@nerdctl-1-4-0:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-1-4-0:~# nerdctl build -t foo .
root@nerdctl-1-4-0:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED           PLATFORM       SIZE        BLOB SIZE
foo            latest    7b4669ddbdfb    34 minutes ago    linux/amd64    16.0 KiB    3.7 KiB
hello-world    latest    96498ffd522e    34 minutes ago    linux/amd64    16.0 KiB    15.8 KiB
hello-world    latest    96498ffd522e    34 minutes ago    linux/386      0.0 B       16.0 KiB
```

### versions

```shell
root@nerdctl-1-4-0:~# nerdctl --version
nerdctl version 1.4.0
root@nerdctl-1-4-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.11.6 2951a28cd7085eb18979b1f710678623d94ed578
root@nerdctl-1-4-0:~# containerd --version
containerd github.com/containerd/containerd v1.7.1 1677a17964311325ed1c31e2c0a3589ce6d5c30d
root@nerdctl-1-4-0:~# runc --version
runc version 1.1.7
commit: v1.1.7-0-g860f061b
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
root@nerdctl-1-4-0:~# cat /etc/os-release
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
root@nerdctl-1-4-0:~# uname -a
Linux nerdctl-1-4-0 5.15.0-185-generic #195-Ubuntu SMP Fri Jun 19 17:11:50 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nerdctl/v1.4.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v1.4.0:ctr_v0.1.0
```
