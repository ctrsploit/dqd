# runc v1.4.2 (kernel v4.15)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.4.2-kernel-v4.15:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.4.2-kernel-v4.15:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.4.2-kernel-v4.15:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up runc/v1.4.2-kernel-v4.15
$ ssh dqd-runc-v1.4.2-kernel-v4.15
```

Fallback without dqd CLI or SSH config:

```shell
$ cd runc/v1.4.2-kernel-v4.15
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with runc

```shell
root@runc-1-4-2-kernel-4-15:~# mkdir -p rootfs/bin/
root@runc-1-4-2-kernel-4-15:~# cp /bin/busybox rootfs/bin/
root@runc-1-4-2-kernel-4-15:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-1-4-2-kernel-4-15:~# runc spec
root@runc-1-4-2-kernel-4-15:~# runc run container-1


BusyBox v1.27.2 (Ubuntu 1:1.27.2-2ubuntu3.4) built-in shell (ash)
Enter 'help' for a list of built-in commands.

/ # 
```

### versions

```shell
root@runc-1-4-2-kernel-4-15:~# runc --version
runc version 1.4.2
commit: v1.4.2-0-gc241c0bb
spec: 1.3.0
go: go1.25.8
libseccomp: 2.6.0
root@runc-1-4-2-kernel-4-15:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.6 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.6 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
root@runc-1-4-2-kernel-4-15:~# uname -a
Linux runc-1-4-2-kernel-4-15 4.15.0-213-generic #224-Ubuntu SMP Mon Jun 19 13:30:12 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/v1.4.2-kernel-v4.15
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.4.2-kernel-v4.15:ctr_v0.1.0
```
