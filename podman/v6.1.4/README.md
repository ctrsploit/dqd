# podman v6.1.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4:v0.1.0 | podman 6.1.4 (source build) on `ghcr.io/ctrsploit/fedora-45` (podman 6.1.x's native distro; 6.1-era crun/conmon/netavark from the f45 release repos) |
| ctr | ghcr.io/ctrsploit/podman-v6.1.4:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v6.1.4
$ ssh dqd-podman-v6.1.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v6.1.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman

```shell
[root@podman-6-1-4 ~]# podman run hello-world
<!-- VERIFY -->
```

### versions

```shell
[root@podman-6-1-4 ~]# podman version
<!-- VERIFY -->
[root@podman-6-1-4 ~]# crun --version
<!-- VERIFY -->
[root@podman-6-1-4 ~]# cat /etc/os-release
<!-- VERIFY -->
[root@podman-6-1-4 ~]# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=podman/v6.1.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v6.1.4:ctr_v0.1.0
```
