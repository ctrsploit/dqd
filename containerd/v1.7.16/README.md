# containerd v1.7.16

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v1.7.16:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v1.7.16:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v1.7.16_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:containerd-v1.7.16_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v1.7.16:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.7.16_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.7.16_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v1.7.16
$ ssh dqd-containerd-v1.7.16
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v1.7.16
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-1-7-16:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-1-7-16:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-1-7-16:~# containerd --version
<!-- VERIFY -->
root@containerd-1-7-16:~# runc --version
<!-- VERIFY -->
root@containerd-1-7-16:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-1-7-16:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v1.7.16
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v1.7.16:ctr_v0.1.0
```
