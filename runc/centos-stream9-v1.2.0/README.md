# runc v1.2.0 CentOS Stream 9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/centos-stream9-runc-v1.2.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/centos-stream9-runc-v1.2.0:v0.1.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up runc/centos-stream9-v1.2.0
$ ssh dqd-centos-stream9-runc-v1.2.0
```

### Run a container with runc

```shell
[root@runc-centos-stream9-v1-2-0 ~]# runc --version
<!-- VERIFY -->
[root@runc-centos-stream9-v1-2-0 ~]# cat /etc/os-release
<!-- VERIFY -->
[root@runc-centos-stream9-v1-2-0 ~]# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/centos-stream9-v1.2.0
```
