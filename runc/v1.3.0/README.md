# runc v1.3.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.3.0:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.3.0:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:runc-v1.3.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.3.0:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.3.0_v0.1.0 | - |

## usage

```shell
$ cd runc/v1.3.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

### run a container

```shell
root@runc-1-3-0:~# mkdir -p rootfs/bin/
root@runc-1-3-0:~# cp /bin/busybox rootfs/bin/
root@runc-1-3-0:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-1-3-0:~# runc spec
root@runc-1-3-0:~# runc run container-1


BusyBox v1.36.1 (Ubuntu 1:1.36.1-6ubuntu3.1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

~ #
```

### versions

```shell
$ ./ssh
root@runc-1-3-0:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@runc-1-3-0:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.2 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.2 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
```

## build

```shell
make all ENV=runc/v1.3.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.3.0:ctr_v0.2.0
```
