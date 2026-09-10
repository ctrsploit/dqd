# containerd v2.3.5

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.5:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.5:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.3.5:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.3.5
$ ssh dqd-containerd-v2.3.5
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.3.5
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with ctr

```shell
root@containerd-2-3-5:~# ctr i pull docker.io/library/hello-world:latest
<!-- VERIFY -->
root@containerd-2-3-5:~# ctr run --rm docker.io/library/hello-world:latest hello
<!-- VERIFY -->
```

### versions

```shell
root@containerd-2-3-5:~# containerd --version
<!-- VERIFY -->
root@containerd-2-3-5:~# runc --version
<!-- VERIFY -->
root@containerd-2-3-5:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-2-3-5:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v2.3.5
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.3.5:ctr_v0.1.0
```
