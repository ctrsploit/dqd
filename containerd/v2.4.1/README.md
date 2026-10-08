# containerd v2.4.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.4.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.4.1:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.4.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.4.1
$ ssh dqd-containerd-v2.4.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.4.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with ctr

```shell
root@containerd-2-4-1:~# ctr i pull docker.io/library/hello-world:latest
docker.io/library/hello world:latest  saved
└──index (5e2309035332)                   complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (8fd8355009a7)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (53a44abb8cdc)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (5099b89d7666)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (eb84fdc6f2a3)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (d1a8d0a4eeb6)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  ├──config (e2ac70e7319a)            complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──layer (4f55086f7dd0)             extracted    |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (8e752a1cddea)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (4cc5f49f1578)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (b7478cec8e46)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (3cc363741441)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (d31545c149fa)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (db7901109959)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (2e4eda001761)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (29af53c4e881)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (8b1c82551095)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (c9ef0047ccf0)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (ecb43d43395e)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (02c0e64f19f3)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (86e7dd6b0bff)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (a2a53259428d)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (3a82e85498a4)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (e8c94468cd6a)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (670045644a15)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (e120a30d867c)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (09538a1f51d3)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (58011732f3fb)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (fb038e8f2e79)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (854472469431)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (5a67e54fddf8)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (ca53543f9482)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (0d11755bbdbe)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (bbfe3d95f71b)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (156fcb9ee881)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (b92bb8a16640)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (2fcf8944aa49)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (b3d311a04be1)            complete     |++++++++++++++++++++++++++++++++++++++|
   ├──manifest (0ede91707e26)             complete     |++++++++++++++++++++++++++++++++++++++|
   │  └──config (d2367c075a7c)            complete     |++++++++++++++++++++++++++++++++++++++|
   └──manifest (d08be0dd652a)             complete     |++++++++++++++++++++++++++++++++++++++|
      └──config (8f3d354c1e09)            complete     |++++++++++++++++++++++++++++++++++++++|
application/vnd.oci.image.index.v1+json sha256:5e23090353324d887c48ad5e5c56d294eab81588df9605b07d1afe895f9cc8f8
Completed pull from OCI Registry (docker.io/library/hello-world:latest)  elapsed: 11.8s  total:  38.9 K  (3.3 KiB/s)
root@containerd-2-4-1:~# ctr run --rm docker.io/library/hello-world:latest hello

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed the output to the Docker client, which sent it
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
root@containerd-2-4-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.4.1 f2551031d7276a770f65f98c9b52e57e7dad07e8
root@containerd-2-4-1:~# runc --version
runc version 1.5.1
commit: v1.5.1-0-g8f2685a47
spec: 1.3.0
go: go1.25.12
libseccomp: 2.6.0
libpathrs: 0.2.5
root@containerd-2-4-1:~# cat /etc/os-release
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
root@containerd-2-4-1:~# uname -a
Linux containerd-2-4-1 6.8.0-146-generic #146-Ubuntu SMP PREEMPT_DYNAMIC Thu Sep 3 16:12:30 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.4.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.4.1:ctr_v0.1.0
```
