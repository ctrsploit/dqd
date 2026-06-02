# runc v1.1.0 (commit 7d09ba1)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.1.0-7d09ba1:latest | points to `v0.2.0` |

## usage

```shell
$ dqd up runc/v1.1.0-7d09ba1
$ ssh dqd-runc-v1.1.0-7d09ba1
```

### versions

```shell
root@runc-1-1-0-7d09ba1:~# runc --version
<!-- VERIFY -->
root@runc-1-1-0-7d09ba1:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-1-1-0-7d09ba1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/v1.1.0-7d09ba1
```
