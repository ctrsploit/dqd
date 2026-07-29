# containerd v2.3.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.0:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.0:v0.2.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.3.0:ctr_v0.2.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.3.0
$ ssh dqd-containerd-v2.3.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.3.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-3-0:~# ctr i pull docker.io/library/hello-world:latest
<!-- VERIFY -->
root@containerd-2-3-0:~# ctr run docker.io/library/hello-world:latest hello
<!-- VERIFY -->
```

### versions

```shell
root@containerd-2-3-0:~# containerd --version
<!-- VERIFY -->
root@containerd-2-3-0:~# runc --version
<!-- VERIFY -->
root@containerd-2-3-0:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-2-3-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v2.3.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.3.0:ctr_v0.2.0
```
