# containerd v2.1.1-debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.1-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.1-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.1.1-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.1.1-debug:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.1.1-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.1.1-debug
$ ssh dqd-containerd-v2.1.1-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.1.1-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### debug mode

debug scripts for each binary:

| binary | host port |
|--------|-----------|
| runc | 21103 |
| ctr | 21105 |
| containerd | 21106 |
| containerd-stress | 21107 |
| containerd-shim-runc-v2 | 21108 |

### versions

```shell
root@containerd-2-1-1-debug:~# containerd --version
<!-- VERIFY -->
root@containerd-2-1-1-debug:~# runc --version
<!-- VERIFY -->
root@containerd-2-1-1-debug:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-2-1-1-debug:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v2.1.1-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.1.1-debug:ctr_v0.1.0
```
