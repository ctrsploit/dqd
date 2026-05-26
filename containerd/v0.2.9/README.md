# containerd v0.2.9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v0.2.9:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v0.2.9:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v0.2.9_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v0.2.9:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v0.2.9_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v0.2.9
$ ssh dqd-containerd-v0.2.9
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v0.2.9
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### versions

```shell
root@containerd-0-2-9:~# containerd --version
<!-- VERIFY -->
root@containerd-0-2-9:~# runc --version
<!-- VERIFY -->
root@containerd-0-2-9:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-0-2-9:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v0.2.9
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v0.2.9:ctr_v0.1.0
```
