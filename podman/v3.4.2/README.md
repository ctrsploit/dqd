# podman v3.4.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v3.4.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v3.4.2:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/podman-v3.4.2:ctr_v0.1.0 | install podman 3.4.2 (kubic) on Ubuntu 20.04 |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v3.4.2
$ ssh dqd-podman-v3.4.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v3.4.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman

```shell
root@podman-3-4-2:~# podman run hello-world
<!-- VERIFY -->
```

### versions

```shell
root@podman-3-4-2:~# podman version
<!-- VERIFY -->
root@podman-3-4-2:~# runc --version
<!-- VERIFY -->
root@podman-3-4-2:~# cat /etc/os-release
<!-- VERIFY -->
root@podman-3-4-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=podman/v3.4.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v3.4.2:ctr_v0.1.0
```
