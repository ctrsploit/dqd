# containerd v2.2.3

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.2.3:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.2.3:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.2.3:ctr_v0.1.0 | - |

## usage

### start up

```shell
$ cd containerd/v2.2.3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

### run a container

```shell
```

### versions

```shell
$ ./ssh

```

## build

```shell
make all ENV=containerd/v2.2.3
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.2.3:ctr_v0.1.0
```
