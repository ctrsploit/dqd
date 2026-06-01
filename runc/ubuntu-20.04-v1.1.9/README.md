# runc v1.1.9 Ubuntu 20.04

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-20.04-runc-v1.1.9:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-20.04-runc-v1.1.9:v0.2.0 | migrate from docker_archive |

## usage

### Start and connect

```shell
$ dqd up runc/ubuntu-20.04-v1.1.9
$ ssh dqd-ubuntu-20.04-runc-v1.1.9
```

### Run a container with runc

```shell
root@runc-ubuntu-20-04-v1-1-9:~# runc --version
<!-- VERIFY -->
root@runc-ubuntu-20-04-v1-1-9:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-ubuntu-20-04-v1-1-9:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/ubuntu-20.04-v1.1.9
```
