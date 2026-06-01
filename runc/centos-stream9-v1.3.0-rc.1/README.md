# runc v1.3.0-rc.1 CentOS Stream 9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/centos-stream9-runc-v1.3.0-rc.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/centos-stream9-runc-v1.3.0-rc.1:v0.1.0 | migrate from docker_archive |

## usage

```shell
$ dqd up runc/centos-stream9-v1.3.0-rc.1
$ ssh dqd-centos-stream9-runc-v1.3.0-rc.1
```

### versions

```shell
[root@runc-centos-stream9-v1-3-0-rc-1 ~]# runc --version
<!-- VERIFY -->
[root@runc-centos-stream9-v1-3-0-rc-1 ~]# cat /etc/os-release
<!-- VERIFY -->
[root@runc-centos-stream9-v1-3-0-rc-1 ~]# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/centos-stream9-v1.3.0-rc.1
```
