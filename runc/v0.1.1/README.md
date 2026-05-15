# runc v0.1.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v0.1.1:latest | points to `v0.3.0` |
| dqd | ghcr.io/ctrsploit/runc-v0.1.1:v0.3.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:runc-v0.1.1_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:runc-v0.1.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v0.1.1:ctr_v0.3.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v0.1.1_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_runc-v0.1.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up runc/v0.1.1
$ ssh dqd-runc-v0.1.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd runc/v0.1.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@runc-0-1-1:~# mkdir -p rootfs/bin/
root@runc-0-1-1:~# cp /bin/busybox rootfs/bin/
root@runc-0-1-1:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-0-1-1:~# runc spec
root@runc-0-1-1:~# runc start container-1


BusyBox v1.22.1 (Ubuntu 1:1.22.0-15ubuntu1.4) built-in shell (ash)
Enter 'help' for a list of built-in commands.

/ #
```

### versions

```shell
root@runc-0-1-1:~# runc --version
runc version 0.1.1
commit: bf8860ae7c76bf6eac5b0f04d32a06aed56bb79c
spec: 0.5.0-dev
root@runc-0-1-1:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.7 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.7 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
root@runc-0-1-1:~# uname -a
Linux runc-0-1-1 4.4.0-210-generic #242-Ubuntu SMP Fri Apr 16 09:57:56 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/v0.1.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v0.1.1:ctr_v0.3.0
```
