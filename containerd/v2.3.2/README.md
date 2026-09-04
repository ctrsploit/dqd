# containerd v2.3.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.2:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.3.2:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.3.2
$ ssh dqd-containerd-v2.3.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.3.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with ctr

```shell
root@containerd-2-3-2:~# ctr i pull docker.io/library/hello-world:latest
docker.io/library/hello-world:latest:                                             resolved       |++++++++++++++++++++++++++++++++++++++|
index-sha256:5dd0d3e6e255913fc30f90b9f2b1d359cc2cbdb48090cc4b65f1676e203243cc:    done           |++++++++++++++++++++++++++++++++++++++|
manifest-sha256:acb5b18edfad3d29c7a5feb303e8fcff0f1e55e7e324e6f3ecdb7d0c8ce6094c: done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:478f9a83e9c54d074ed5b1fee34f40a50b5e61cc1b06ba2db9c17b5a0e14b5cd:    done           |++++++++++++++++++++++++++++++++++++++|
config-sha256:17a6dd1d8f7ac2b87bfe89c32084ea074c7bad2f4bd4d55b2ee26db4a58eb6ca:   done           |++++++++++++++++++++++++++++++++++++++|
elapsed: 12.7 s                                                                   total:  13.3 K (1.0 KiB/s)
unpacking linux/amd64 sha256:5dd0d3e6e255913fc30f90b9f2b1d359cc2cbdb48090cc4b65f1676e203243cc...
done: 17.872334ms
root@containerd-2-3-2:~# ctr run --rm docker.io/library/hello-world:latest hello
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
root@containerd-2-3-2:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.3.2 fff62f14765df376e5fc36f5a8f8e795b5670f61
root@containerd-2-3-2:~# runc --version
runc version 1.4.3
commit: v1.4.3-0-gbb14dabeb
spec: 1.3.0
go: go1.25.11
libseccomp: 2.6.0
root@containerd-2-3-2:~# cat /etc/os-release
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
root@containerd-2-3-2:~# uname -a
Linux containerd-2-3-2 6.8.0-139-generic #139-Ubuntu SMP PREEMPT_DYNAMIC Sat Aug  1 03:52:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.3.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.3.2:ctr_v0.1.0
```
