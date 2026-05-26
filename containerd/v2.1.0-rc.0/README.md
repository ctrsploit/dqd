# containerd v2.1.0-rc.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.0-rc.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.0-rc.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.1.0-rc.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.1.0-rc.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.1.0-rc.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.1.0-rc.0
$ ssh dqd-containerd-v2.1.0-rc.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.1.0-rc.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### versions

```shell
root@containerd-2-1-0-rc-0:~# containerd --version
<!-- VERIFY -->
root@containerd-2-1-0-rc-0:~# runc --version
<!-- VERIFY -->
root@containerd-2-1-0-rc-0:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-2-1-0-rc-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v2.1.0-rc.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.1.0-rc.0:ctr_v0.1.0
```
