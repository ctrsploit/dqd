# containerd v1.7.15

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v1.7.15:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v1.7.15:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v1.7.15_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v1.7.15:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.7.15_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v1.7.15
$ ssh dqd-containerd-v1.7.15
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v1.7.15
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-1-7-15:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-1-7-15:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-1-7-15:~# containerd --version
<!-- VERIFY -->
root@containerd-1-7-15:~# runc --version
<!-- VERIFY -->
root@containerd-1-7-15:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-1-7-15:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v1.7.15
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v1.7.15:ctr_v0.1.0
```
