# cgroup v1 builder

This dqd runtime exists for CI builds that need a cgroup v1 host environment.

## usage

### Start and connect

```shell
$ dqd up dqd/cgroup-v1-builder
$ ssh dqd-cgroup-v1-builder
```

## build

```shell
make all ENV=dqd/cgroup-v1-builder
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/cgroup-v1-builder:ctr_v0.1.0
```
