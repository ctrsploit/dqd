# containerd v2.1.0-debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.0-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.0-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.1.0-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.1.0-debug:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.1.0-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.1.0-debug
$ ssh dqd-containerd-v2.1.0-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.1.0-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### debug mode

debug scripts for each binary:

| binary | host port |
|--------|-----------|
| runc | 21013 |
| ctr | 21015 |
| containerd | 21016 |
| containerd-stress | 21017 |
| containerd-shim-runc-v2 | 21018 |

Use `debug.sh runc`, `debug.sh ctr`, etc. to start debugging.

### attach to init

```shell
root@containerd-2-1-0-debug:~# attach.sh <pid>
```

### versions

```shell
root@containerd-2-1-0-debug:~# containerd --version
<!-- VERIFY -->
root@containerd-2-1-0-debug:~# runc --version
<!-- VERIFY -->
root@containerd-2-1-0-debug:~# cat /etc/os-release
<!-- VERIFY -->
root@containerd-2-1-0-debug:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=containerd/v2.1.0-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.1.0-debug:ctr_v0.1.0
```
