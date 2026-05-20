# runc v1.0.0-rc93

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.0.0-rc93:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.0.0-rc93:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:runc-v1.0.0-rc93_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:runc-v1.0.0-rc93_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.0.0-rc93:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.0.0-rc93_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.0.0-rc93_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up runc/v1.0.0-rc93
$ ssh dqd-runc-v1.0.0-rc93
```

Fallback without dqd CLI or SSH config:

```shell
$ cd runc/v1.0.0-rc93
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@runc-1-0-0-rc93:~# mkdir -p rootfs/bin/
root@runc-1-0-0-rc93:~# cp /bin/busybox rootfs/bin/
root@runc-1-0-0-rc93:~# ln -s /bin/busybox rootfs/bin/sh
root@runc-1-0-0-rc93:~# runc spec
root@runc-1-0-0-rc93:~# runc run container-1


BusyBox v1.36.1 (Ubuntu 1:1.36.1-6ubuntu3.1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

/ #
```

### versions

```shell
root@runc-1-0-0-rc93:~# runc --version
<!-- VERIFY -->
root@runc-1-0-0-rc93:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-1-0-0-rc93:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=runc/v1.0.0-rc93
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.0.0-rc93:ctr_v0.1.0
```
