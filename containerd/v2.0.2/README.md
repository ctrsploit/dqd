# containerd v2.0.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.2:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.0.2_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:containerd-v2.0.2_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.0.2:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.2_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.2_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.0.2
$ ssh dqd-containerd-v2.0.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.0.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-0-2:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-0-2:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-2-0-2:~# containerd --version
<!-- VERIFY -->
root@containerd-2-0-2:~# runc --version
<!-- VERIFY -->
root@containerd-2-0-2:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-2-0-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v2.0.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.0.2:ctr_v0.1.0
```
