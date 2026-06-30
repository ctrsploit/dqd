# nerdctl v0.20.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v0.20.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v0.20.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v0.20.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v0.20.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v0.20.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v0.20.0
$ ssh dqd-nerdctl-v0.20.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v0.20.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-0-20-0:~# nerdctl run --security-opt apparmor=unconfined hello-world

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

root@nerdctl-0-20-0:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-0-20-0:~# nerdctl build -t foo .
root@nerdctl-0-20-0:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED                   PLATFORM       SIZE        BLOB SIZE
foo            latest    d7173a0a1c25    Less than a second ago    linux/amd64    16.0 KiB    3.7 KiB
hello-world    latest    96498ffd522e    30 seconds ago            linux/amd64    16.0 KiB    15.8 KiB
hello-world    latest    96498ffd522e    30 seconds ago            linux/386      0.0 B       16.0 KiB
```

### versions

```shell
root@nerdctl-0-20-0:~# nerdctl --version
nerdctl version 0.20.0
root@nerdctl-0-20-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.10.3 c8d25d9a103b70dc300a4fd55e7e576472284e31
root@nerdctl-0-20-0:~# containerd --version
containerd github.com/containerd/containerd v1.6.4 212e8b6fa2f44b9c21b2798135fc6fb7c53efc16
root@nerdctl-0-20-0:~# runc --version
runc version 1.0.0-rc95
spec: 1.0.2-dev
go: go1.14.15
libseccomp: 2.5.1
root@nerdctl-0-20-0:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.6 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.6 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
root@nerdctl-0-20-0:~# uname -a
Linux nerdctl-0-20-0 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nerdctl/v0.20.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v0.20.0:ctr_v0.1.0
```

## Known Issue

### apparmor_parser

https://github.com/containerd/nerdctl/issues/3945

```
root@nerdctl-0-20-0:~# nerdctl run hello-world
time="2026-06-30T10:06:04Z" level=fatal msg="get apparmor_parser version: exec: \"apparmor_parser\": executable file not found in $PATH"
```
