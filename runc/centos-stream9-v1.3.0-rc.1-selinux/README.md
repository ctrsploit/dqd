# runc v1.3.0-rc.1 CentOS Stream 9 SELinux

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/centos-stream9-runc-v1.3.0-rc.1-selinux:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/centos-stream9-runc-v1.3.0-rc.1-selinux:v0.1.0 | migrate from docker_archive |

## usage

```shell
$ dqd up runc/centos-stream9-v1.3.0-rc.1-selinux
$ ssh dqd-centos-stream9-runc-v1.3.0-rc.1-selinux
```

### versions

```shell
[root@runc-centos-stream9-v1-3-0-rc-1-selinux ~]# runc --version
runc version 1.3.0-rc.1
commit: v1.3.0-rc.1-0-ga00ce11e
spec: 1.2.1
go: go1.23.6
libseccomp: 2.5.6
[root@runc-centos-stream9-v1-3-0-rc-1-selinux ~]# cat /etc/os-release
NAME="CentOS Stream"
VERSION="9"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="9"
PLATFORM_ID="platform:el9"
PRETTY_NAME="CentOS Stream 9"
ANSI_COLOR="0;31"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:centos:centos:9"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://issues.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 9"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
[root@runc-centos-stream9-v1-3-0-rc-1-selinux ~]# uname -a
Linux runc-centos-stream9-v1-3-0-rc-1-selinux 5.14.0-708.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Wed May 20 09:11:55 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=runc/centos-stream9-v1.3.0-rc.1-selinux
```
