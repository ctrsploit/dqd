# podman v3.0.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v3.0.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v3.0.1:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/podman-v3.0.1:ctr_v0.1.0 | podman 3.0.1 stack from Debian bullseye on Ubuntu 20.04 |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v3.0.1
$ ssh dqd-podman-v3.0.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v3.0.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman

```shell
root@podman-3-0-1:~# podman run hello-world
<!-- VERIFY -->
```

### versions

```shell
root@podman-3-0-1:~# podman version
<!-- VERIFY -->
root@podman-3-0-1:~# crun --version
<!-- VERIFY -->
root@podman-3-0-1:~# cat /etc/os-release
<!-- VERIFY -->
root@podman-3-0-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=podman/v3.0.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v3.0.1:ctr_v0.1.0
```
