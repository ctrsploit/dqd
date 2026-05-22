# containerd v2.0.4 with fuse-overlayfs

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.4-fuse-overlayfs:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.4-fuse-overlayfs:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.0.4-fuse-overlayfs_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:containerd-v2.0.4-fuse-overlayfs_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.0.4-fuse-overlayfs:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.4-fuse-overlayfs_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.4-fuse-overlayfs_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.0.4-fuse-overlayfs
$ ssh dqd-containerd-v2.0.4-fuse-overlayfs
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.0.4-fuse-overlayfs
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-0-4-fuse-overlayfs:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-0-4-fuse-overlayfs:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### verify fuse-overlayfs

```shell
root@containerd-2-0-4-fuse-overlayfs:~# systemctl status containerd-fuse-overlayfs
<!-- VERIFY -->
root@containerd-2-0-4-fuse-overlayfs:~# systemctl status containerd
<!-- VERIFY -->
```

### versions

```shell
root@containerd-2-0-4-fuse-overlayfs:~# containerd --version
<!-- VERIFY -->
root@containerd-2-0-4-fuse-overlayfs:~# runc --version
<!-- VERIFY -->
root@containerd-2-0-4-fuse-overlayfs:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-2-0-4-fuse-overlayfs:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v2.0.4-fuse-overlayfs
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.0.4-fuse-overlayfs:ctr_v0.1.0
```
