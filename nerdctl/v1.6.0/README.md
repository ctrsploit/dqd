# nerdctl v1.6.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.6.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.6.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v1.6.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v1.6.0:ctr_v0.1.0 | based on dqd `containerd-v1.7.6:ctr_v0.1.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v1.6.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v1.6.0
$ ssh dqd-nerdctl-v1.6.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v1.6.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-1-6-0:~# nerdctl run hello-world

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
root@nerdctl-1-6-0:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-1-6-0:~# nerdctl build -t foo .
root@nerdctl-1-6-0:~# nerdctl images
REPOSITORY     TAG       IMAGE ID        CREATED                   PLATFORM       SIZE        BLOB SIZE
foo            latest    5e9687c348ae    Less than a second ago    linux/amd64    16.0 KiB    3.4 KiB
hello-world    latest    96498ffd522e    24 seconds ago            linux/amd64    16.0 KiB    15.8 KiB
hello-world    latest    96498ffd522e    24 seconds ago            linux/386      0.0 B       16.0 KiB
```

### versions

```shell
root@nerdctl-1-6-0:~# nerdctl --version
nerdctl version 1.6.0
root@nerdctl-1-6-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.12.2 567a99433ca23402d5e9b9f9124005d2e59b8861
root@nerdctl-1-6-0:~# containerd --version
containerd github.com/containerd/containerd v1.7.6 091922f03c2762540fd057fba91260237ff86acb
root@nerdctl-1-6-0:~# runc --version
runc version 1.1.9
commit: v1.1.9-0-gccaecfcb
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
root@nerdctl-1-6-0:~# cat /etc/os-release
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
root@nerdctl-1-6-0:~# uname -a
Linux nerdctl-1-6-0 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nerdctl/v1.6.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v1.6.0:ctr_v0.1.0
```
