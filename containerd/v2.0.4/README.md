# containerd v2.0.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.4:latest | points to `v0.3.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.4:v0.3.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.0.4_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:containerd-v2.0.4_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.0.4:ctr_v0.3.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.4_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.4_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.0.4
$ ssh dqd-containerd-v2.0.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.0.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-0-4:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-0-4:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
$ ssh dqd-containerd-v2.0.4
root@containerd-2-0-4:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.4 1a43cb6a1035441f9aca8f5666a9b3ef9e70ab20
root@containerd-2-0-4:~# runc --version
runc version 1.2.5
commit: v1.2.5-0-g59923ef1
spec: 1.2.0
go: go1.22.12
libseccomp: 2.5.5
```

## build

```shell
make all ENV=containerd/v2.0.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.0.4:ctr_v0.3.0
```
