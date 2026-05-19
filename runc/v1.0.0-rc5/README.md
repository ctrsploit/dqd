# runc v1.0.0-rc5

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.0.0-rc5:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.0.0-rc5:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:runc-v1.0.0-rc5_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:runc-v1.0.0-rc5_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.0.0-rc5:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.0.0-rc5_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.0.0-rc5_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up runc/v1.0.0-rc5
$ ssh dqd-runc-v1.0.0-rc5
```

Fallback without dqd CLI or SSH config:

```shell
$ cd runc/v1.0.0-rc5
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@runc-1-0-0-rc5:~# mkdir -p rootfs/bin/
root@runc-1-0-0-rc5:~# cp /bin/busybox rootfs/bin/
root@runc-1-0-0-rc5:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-1-0-0-rc5:~# runc spec
root@runc-1-0-0-rc5:~# runc run container-1


BusyBox v1.30.1 (Ubuntu 1:1.30.1-4ubuntu6.5) built-in shell (ash)
Enter 'help' for a list of built-in commands.

/ #
```

### versions

```shell
root@runc-1-0-0-rc5:~# runc --version
runc version 1.0.0-rc5
spec: 1.0.0
root@runc-1-0-0-rc5:~# cat /etc/os-release
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
root@runc-1-0-0-rc5:~# uname -a
Linux runc-1-0-0-rc5 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/v1.0.0-rc5
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.0.0-rc5:ctr_v0.1.0
```
