# runc v1.5.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.5.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.5.1:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.5.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up runc/v1.5.1
$ ssh dqd-runc-v1.5.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd runc/v1.5.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with runc

```shell
root@runc-1-5-1:~# mkdir -p rootfs/bin/
root@runc-1-5-1:~# cp /bin/busybox rootfs/bin/
root@runc-1-5-1:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-1-5-1:~# runc spec
root@runc-1-5-1:~# runc run container-1
<!-- VERIFY -->
```

### versions

```shell
root@runc-1-5-1:~# runc --version
<!-- VERIFY -->
root@runc-1-5-1:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-1-5-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/v1.5.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.5.1:ctr_v0.1.0
```
