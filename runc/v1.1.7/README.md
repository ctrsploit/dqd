# runc v1.1.7

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.1.7:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.1.7:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:runc-v1.1.7_v0.3.0 | bump the base image |
| dqd | ssst0n3/docker_archive:runc-v1.1.7_v0.2.0 | - |
| dqd | ssst0n3/docker_archive:runc-v1.1.7_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.1.7:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.1.7_v0.3.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.1.7_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.1.7_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up runc/v1.1.7
$ ssh dqd-runc-v1.1.7
```

Fallback without dqd CLI or SSH config:

```shell
$ cd runc/v1.1.7
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@runc-1-1-7:~# mkdir -p rootfs/bin/
root@runc-1-1-7:~# cp /bin/busybox rootfs/bin/
root@runc-1-1-7:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-1-1-7:~# runc spec
root@runc-1-1-7:~# runc run container-1


BusyBox v1.30.1 (Ubuntu 1:1.30.1-7ubuntu3.1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

/ #
```

### versions

```shell
root@runc-1-1-7:~# runc --version
runc version 1.1.7
commit: v1.1.7-0-g860f061b
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
root@runc-1-1-7:~# cat /etc/os-release
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
root@runc-1-1-7:~# uname -a
Linux runc-1-1-7 5.15.0-179-generic #189-Ubuntu SMP Tue May 5 18:20:56 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/v1.1.7
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.1.7:ctr_v0.1.0
```
