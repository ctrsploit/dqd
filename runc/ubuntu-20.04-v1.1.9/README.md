# runc v1.1.9 Ubuntu 20.04

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-20.04-runc-v1.1.9:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-20.04-runc-v1.1.9:v0.2.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up runc/ubuntu-20.04-v1.1.9
$ ssh dqd-ubuntu-20.04-runc-v1.1.9
```

### Run a container with runc

```shell
root@runc-ubuntu-20-04-v1-1-9:~# runc --version
runc version 1.1.9
commit: v1.1.9-0-gccaecfcb
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
root@runc-ubuntu-20-04-v1-1-9:~# cat /etc/os-release
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
root@runc-ubuntu-20-04-v1-1-9:~# uname -a
Linux runc-ubuntu-20-04-v1-1-9 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/ubuntu-20.04-v1.1.9
```
