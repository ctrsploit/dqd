# runc v1.3.5

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.3.5:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.3.5:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.3.5:ctr_v0.1.0 | - |

## usage

```shell
$ cd runc/v1.3.5
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

### run a container

```shell
root@runc-1-3-5:~# mkdir -p rootfs/bin/
root@runc-1-3-5:~# cp /bin/busybox rootfs/bin/
root@runc-1-3-5:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-1-3-5:~# runc spec
root@runc-1-3-5:~# runc run container-1


BusyBox v1.36.1 (Ubuntu 1:1.36.1-6ubuntu3.1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

~ # 
```

### versions

```shell
$ ./ssh
root@runc-1-3-5:~# runc --version
runc version 1.3.5
commit: v1.3.5-0-g488fc13e
spec: 1.2.1
go: go1.25.8
libseccomp: 2.6.0
root@runc-1-3-5:~# cat /etc/os-release
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
root@runc-1-3-5:~# uname -a
Linux runc-1-3-5 6.8.0-110-generic #110-Ubuntu SMP PREEMPT_DYNAMIC Thu Mar 19 15:09:20 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/v1.3.5
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.3.5:ctr_v0.1.0
```
