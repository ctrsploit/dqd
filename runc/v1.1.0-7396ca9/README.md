# runc v1.1.0 (commit 7396ca9)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.1.0-7396ca9:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.1.0-7396ca9:v0.2.0 | migrate from docker_archive |

## usage

```shell
$ dqd up runc/v1.1.0-7396ca9
$ ssh dqd-runc-v1.1.0-7396ca9
```

### versions

```shell
root@runc-1-1-0-7396ca9:~# runc --version
<!-- VERIFY -->
root@runc-1-1-0-7396ca9:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-1-1-0-7396ca9:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/v1.1.0-7396ca9
```
