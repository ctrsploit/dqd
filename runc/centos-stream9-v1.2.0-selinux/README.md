# runc v1.2.0 CentOS Stream 9 SELinux

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/centos-stream9-runc-v1.2.0-selinux:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/centos-stream9-runc-v1.2.0-selinux:v0.1.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up runc/centos-stream9-v1.2.0-selinux
$ ssh dqd-centos-stream9-runc-v1.2.0-selinux
```

### versions

```shell
[root@runc-centos-stream9-v1-2-0-selinux ~]# runc --version
<!-- VERIFY -->
[root@runc-centos-stream9-v1-2-0-selinux ~]# cat /etc/os-release
<!-- VERIFY -->
[root@runc-centos-stream9-v1-2-0-selinux ~]# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/centos-stream9-v1.2.0-selinux
```
