# runc v1.3.0-rc.2 CRIU

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.3.0-rc.2-criu:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.3.0-rc.2-criu:v0.1.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up runc/v1.3.0-rc.2-criu
$ ssh dqd-runc-v1.3.0-rc.2-criu
```

### versions

```shell
root@runc-1-3-0-rc-2-criu:~# runc --version
<!-- VERIFY -->
root@runc-1-3-0-rc-2-criu:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-1-3-0-rc-2-criu:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/v1.3.0-rc.2-criu
```
