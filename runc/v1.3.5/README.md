# runc v1.3.5

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.3.5:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.3.5:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.3.5:ctr_v0.1.0 | - |

## usage

```shell
$ cd runc/v1.3.5
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
make all ENV=runc/v1.3.5
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.3.5:ctr_v0.1.0
```
