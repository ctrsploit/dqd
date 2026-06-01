# runc v1.3.0-rc.1 CRIU

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.3.0-rc.1-criu:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.3.0-rc.1-criu:v0.1.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up runc/v1.3.0-rc.1-criu
$ ssh dqd-runc-v1.3.0-rc.1-criu
```

### versions

```shell
root@runc-1-3-0-rc-1-criu:~# runc --version
runc version 1.3.0-rc.1
commit: v1.3.0-rc.1-0-ga00ce11e
spec: 1.2.1
go: go1.23.6
libseccomp: 2.5.6
root@runc-1-3-0-rc-1-criu:~# cat /etc/os-release
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
root@runc-1-3-0-rc-1-criu:~# uname -a
Linux runc-1-3-0-rc-1-criu 6.8.0-124-generic #124-Ubuntu SMP PREEMPT_DYNAMIC Tue May 26 13:00:45 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/v1.3.0-rc.1-criu
```
