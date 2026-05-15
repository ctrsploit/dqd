# containerd v2.1.5

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.5:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.5:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.1.5_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.1.5:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.1.5_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.1.5
$ ssh dqd-containerd-v2.1.5
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.1.5
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-1-5:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-1-5:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

### versions

```shell
root@containerd-2-1-5:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.5 fcd43222d6b07379a4be9786bda52438f0dd16a1
root@containerd-2-1-5:~# runc --version
runc version 1.3.3
commit: v1.3.3-0-gd842d771
spec: 1.2.1
go: go1.23.12
libseccomp: 2.5.6
```

## build

```shell
make all ENV=containerd/v2.1.5
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.1.5:ctr_v0.1.0
```
