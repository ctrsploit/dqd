# runc v1.1.0 (commit a6f4081)
| dqd | ghcr.io/ctrsploit/runc-v1.1.0-a6f4081:v0.2.0 | migrate from docker_archive |

```shell
$ dqd up runc/v1.1.0-a6f4081
$ ssh dqd-runc-v1.1.0-a6f4081
root@runc-1-1-0-a6f4081:~# runc --version
runc version 1.1.0+dev
commit: a6f4081-dirty
spec: 1.1.0+dev
go: go1.20.14
libseccomp: 2.5.4
root@runc-1-1-0-a6f4081:~# cat /etc/os-release
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
root@runc-1-1-0-a6f4081:~# uname -a
Linux runc-1-1-0-a6f4081 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```
