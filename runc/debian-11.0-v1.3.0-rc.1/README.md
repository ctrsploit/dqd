# runc v1.3.0-rc.1 Debian 11.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/debian-11.0-runc-v1.3.0-rc.1:latest | points to `v0.1.0` |

## usage

```shell
$ dqd up runc/debian-11.0-v1.3.0-rc.1
$ ssh dqd-debian-11.0-runc-v1.3.0-rc.1
```

### versions

```shell
root@runc-debian-11-0-v1-3-0-rc-1:~# runc --version
<!-- VERIFY -->
root@runc-debian-11-0-v1-3-0-rc-1:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-debian-11-0-v1-3-0-rc-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/debian-11.0-v1.3.0-rc.1
```
