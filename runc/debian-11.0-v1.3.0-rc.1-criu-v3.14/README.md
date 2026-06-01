# runc v1.3.0-rc.1 Debian 11.0 CRIU v3.14

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/debian-11.0-runc-v1.3.0-rc.1-criu-v3.14:latest | points to `v0.1.0` |

## usage

```shell
$ dqd up runc/debian-11.0-v1.3.0-rc.1-criu-v3.14
$ ssh dqd-debian-11.0-runc-v1.3.0-rc.1-criu-v3.14
```

### versions

```shell
root@runc-debian-11-0-v1-3-0-rc-1-criu-3-14:~# runc --version
runc version 1.3.0-rc.1
commit: v1.3.0-rc.1-0-ga00ce11e
spec: 1.2.1
go: go1.23.6
libseccomp: 2.5.6
root@runc-debian-11-0-v1-3-0-rc-1-criu-3-14:~# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
VERSION_ID="11"
VERSION="11 (bullseye)"
VERSION_CODENAME=bullseye
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
root@runc-debian-11-0-v1-3-0-rc-1-criu-3-14:~# uname -a
Linux runc-debian-11-0-v1-3-0-rc-1-criu-3-14 5.10.0-44-amd64 #1 SMP Debian 5.10.257-1 (2026-05-27) x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/debian-11.0-v1.3.0-rc.1-criu-v3.14
```
