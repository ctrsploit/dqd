# containerd v2.0.3

* dqd: 
    * ghcr.io/ctrsploit/containerd-v2.0.3:latest -> ghcr.io/ctrsploit/containerd-v2.0.3:v0.4.0
    * ghcr.io/ctrsploit/containerd-v2.0.3:v0.4.0
    * ssst0n3/docker_archive:containerd-v2.0.3_v0.3.0
    * ssst0n3/docker_archive:containerd-v2.0.3_v0.2.0
    * ssst0n3/docker_archive:containerd-v2.0.3_v0.1.0
* ctr:
    * ghcr.io/ctrsploit/containerd-v2.0.3:ctr_v0.4.0: migrate from docker_archive
    * ssst0n3/docker_archive:ctr_containerd-v2.0.3_v0.3.0: bump the base image; revert squash
    * ssst0n3/docker_archive:ctr_containerd-v2.0.3_v0.2.0: squash
    * ssst0n3/docker_archive:ctr_containerd-v2.0.3_v0.1.0

## usage

```shell
$ cd containerd/v2.0.3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

### run a container

```shell
root@containerd-2-0-3:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-0-3:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
$ ./ssh
root@containerd-2-0-3:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.3 06b99ca80cdbfbc6cc8bd567021738c9af2b36ce
root@containerd-2-0-3:~# runc --version
runc version 1.2.5
commit: v1.2.5-0-g59923ef1
spec: 1.2.0
go: go1.22.12
libseccomp: 2.5.5
```

## build

```shell
make all DIR=containerd/v2.0.3
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.0.3:ctr_v0.4.0
```
