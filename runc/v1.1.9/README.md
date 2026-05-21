# runc v1.1.9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.1.9:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.1.9:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:runc-v1.1.9_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:runc-v1.1.9_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.1.9:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.1.9_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.1.9_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up runc/v1.1.9
$ ssh dqd-runc-v1.1.9
```

Fallback without dqd CLI or SSH config:

```shell
$ cd runc/v1.1.9
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@runc-1-1-9:~# mkdir -p rootfs/bin/
root@runc-1-1-9:~# cp /bin/busybox rootfs/bin/
root@runc-1-1-9:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-1-1-9:~# runc spec
root@runc-1-1-9:~# runc run container-1


BusyBox v1.36.1 (Ubuntu 1:1.36.1-6ubuntu3.1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

/ #
```

### versions

```shell
root@runc-1-1-9:~# runc --version
runc version 1.1.9
commit: v1.1.9-0-gccaecfcb
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
root@runc-1-1-9:~# cat /etc/os-release
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
root@runc-1-1-9:~# uname -a
Linux runc-1-1-9 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/v1.1.9
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.1.9:ctr_v0.1.0
```
