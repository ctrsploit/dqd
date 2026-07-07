# nerdctl v1.7.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.7.4:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.7.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v1.7.4_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v1.7.4:ctr_v0.1.0 | based on dqd `containerd-v1.7.13:ctr_v0.1.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v1.7.4_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v1.7.4
$ ssh dqd-nerdctl-v1.7.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v1.7.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-1-7-4:~# nerdctl run hello-world

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
root@nerdctl-1-7-4:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-1-7-4:~# nerdctl build -t foo .
root@nerdctl-1-7-4:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED           PLATFORM       SIZE        BLOB SIZE
foo            latest    5e9687c348ae    12 seconds ago    linux/amd64    16.0 KiB    3.4 KiB
hello-world    latest    96498ffd522e    29 seconds ago    linux/amd64    16.0 KiB    15.8 KiB
```

### versions

```shell
root@nerdctl-1-7-4:~# nerdctl --version
nerdctl version 1.7.4
root@nerdctl-1-7-4:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.12.5 bac3f2b673f3f9d33e79046008e7a38e856b3dc6
root@nerdctl-1-7-4:~# containerd --version
containerd github.com/containerd/containerd v1.7.13 7c3aca7a610df76212171d200ca3811ff6096eb8
root@nerdctl-1-7-4:~# runc --version
runc version 1.1.12
commit: v1.1.12-0-g51d5e946
spec: 1.0.2-dev
go: go1.20.13
libseccomp: 2.5.4
root@nerdctl-1-7-4:~# cat /etc/os-release
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
root@nerdctl-1-7-4:~# uname -a
Linux nerdctl-1-7-4 5.15.0-185-generic #195-Ubuntu SMP Fri Jun 19 17:11:50 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nerdctl/v1.7.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v1.7.4:ctr_v0.1.0
```
