# runc v1.2.6 Debian 11.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/debian-11.0-runc-v1.2.6:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/debian-11.0-runc-v1.2.6:v0.1.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up runc/debian-11.0-v1.2.6
$ ssh dqd-debian-11.0-runc-v1.2.6
```

### versions

```shell
root@runc-debian-11-0-v1-2-6:~# runc --version
<!-- VERIFY -->
root@runc-debian-11-0-v1-2-6:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-debian-11-0-v1-2-6:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/debian-11.0-v1.2.6
```
