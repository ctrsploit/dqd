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

```shell
$ cd containerd/v2.0.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
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
$ ./ssh
root@containerd-2-0-4:~# containerd --version
root@containerd-2-0-4:~# runc --version
```

## build

```shell
make all ENV=containerd/v2.0.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.0.4:ctr_v0.3.0
```
