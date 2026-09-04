# containerd v2.3.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.2:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.3.2:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.3.2
$ ssh dqd-containerd-v2.3.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.3.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with ctr

```shell
root@containerd-2-3-2:~# ctr i pull docker.io/library/hello-world:latest
<!-- VERIFY -->
root@containerd-2-3-2:~# ctr run docker.io/library/hello-world:latest hello
<!-- VERIFY -->
```

### versions

```shell
root@containerd-2-3-2:~# containerd --version
<!-- VERIFY -->
root@containerd-2-3-2:~# runc --version
<!-- VERIFY -->
root@containerd-2-3-2:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-2-3-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v2.3.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.3.2:ctr_v0.1.0
```
