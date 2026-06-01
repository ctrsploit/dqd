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
<!-- VERIFY -->
root@runc-debian-11-0-v1-3-0-rc-1-criu-3-14:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-debian-11-0-v1-3-0-rc-1-criu-3-14:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/debian-11.0-v1.3.0-rc.1-criu-v3.14
```
