# containerd v2.1.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.4:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.4:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.1.4_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.1.4:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.1.4_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.1.4
$ ssh dqd-containerd-v2.1.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.1.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-1-4:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-1-4:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

### versions

```shell
root@containerd-2-1-4:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.4 75cb2b7193e4e490e9fbdc236c0e811ccaba3376
root@containerd-2-1-4:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
```

## build

```shell
make all ENV=containerd/v2.1.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.1.4:ctr_v0.2.0
```
