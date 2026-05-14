# ubuntu 22.04 dbg

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-22.04-dbg:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-22.04-dbg:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ubuntu-22.04-dbg_v0.2.0 | - |
| dqd | ssst0n3/docker_archive:ubuntu-22.04-dbg_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/ubuntu-22.04-dbg:ctr_v0.2.0 | base moved to `ghcr.io/ctrsploit/ubuntu-22.04:ctr_v0.3.0` |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-22.04-dbg_v0.2.0 | bump base image to `v0.2.0` |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-22.04-dbg_v0.1.0 | - |

## debug

### Start and connect

Recommended gdb session:

```
$ dqd up ubuntu/22.04-dbg
$ docker exec -ti ubuntu-22-04-dbg-vm-1 bash
root@276954a1c0af:/# gdb /vmlinux
(gdb) target remote :1234
Remote debugging using :1234
0x000000000000fff0 in exception_stacks ()
(gdb) c
Continuing.
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ubuntu/22.04-dbg
$ docker compose up -d
$ ./ssh
```

## env

KVM is not recommended for debugging kernel.

vm:

```shell
$ ssh dqd-ubuntu-22.04-dbg
root@ubuntu22-04:~# uname -a
Linux ubuntu22-04 5.15.0-177-generic #187-Ubuntu SMP Sat Apr 11 22:54:33 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu22-04:~# cat /etc/os-release 
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
```

ctr:

```shell
$ docker exec -ti ubuntu-22-04-dbg-vm-1 bash
root@ca84c82e58c5:/# dpkg -l | awk '$2 ~ /^linux-/'
ii  linux-base                                     4.5ubuntu9+22.04.1                      all          Linux image base package
ii  linux-image-5.15.0-177-generic                 5.15.0-177.187                          amd64        Signed kernel image generic
ii  linux-image-5.15.0-177-generic-dbgsym          5.15.0-177.187                          amd64        Signed kernel image generic
ii  linux-image-unsigned-5.15.0-177-generic-dbgsym 5.15.0-177.187                          amd64        Linux kernel debug image for version 5.15.0 on 64 bit x86 SMP
ii  linux-libc-dev:amd64                           5.15.0-177.187                          amd64        Linux Kernel Headers for development
ii  linux-modules-5.15.0-177-generic               5.15.0-177.187                          amd64        Linux kernel extra modules for version 5.15.0 on 64 bit x86 SMP
ii  linux-source-5.15.0                            5.15.0-177.187                          all          Linux kernel source for version 5.15.0 with Ubuntu patches
```

## build

```shell
make dbg ENV=ubuntu/22.04-dbg
```

CI uses `CI_MAKE_TARGETS` in `.env` to run this debug build flow.

for developers:

Dockerfile.dbg

```dockerfile
FROM ghcr.io/ctrsploit/ubuntu-22.04-dbg:ctr_v0.2.0
```

Dockerfile: as your need
