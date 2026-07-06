# nerdctl v2.1.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.1.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.1.2:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v2.1.2_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v2.1.2:ctr_v0.1.0 | based on dqd `containerd-v2.1.1:ctr_v0.2.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v2.1.2_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v2.1.2
$ ssh dqd-nerdctl-v2.1.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v2.1.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-2-1-2:~# nerdctl run hello-world

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

root@nerdctl-2-1-2:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-2-1-2:~# nerdctl build -t foo .
root@nerdctl-2-1-2:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED           PLATFORM       SIZE       BLOB SIZE
foo            latest    5ab06286eb59    5 seconds ago     linux/amd64    16.38kB    3.491kB
hello-world    latest    96498ffd522e    38 seconds ago    linux/amd64    16.38kB    4.015kB
```

### versions

```shell
root@nerdctl-2-1-2:~# nerdctl --version
nerdctl version 2.1.2
root@nerdctl-2-1-2:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.21.1 66735c67040bc80e6ed104f451683e094030a4e1
root@nerdctl-2-1-2:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.1 cb1076646aa3740577fafbf3d914198b7fe8e3f7
root@nerdctl-2-1-2:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@nerdctl-2-1-2:~# cat /etc/os-release
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
root@nerdctl-2-1-2:~# uname -a
Linux nerdctl-2-1-2 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nerdctl/v2.1.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v2.1.2:ctr_v0.1.0
```
