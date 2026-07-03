# podman v5.4.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v5.4.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v5.4.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:podman-v5.4.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/podman-v5.4.0:ctr_v0.1.0 | install podman 5.4.0 on CentOS Stream 9 |
| ctr | ssst0n3/docker_archive:ctr_podman-v5.4.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v5.4.0
$ ssh dqd-podman-v5.4.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v5.4.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman

```shell
root@podman-5-4-0:~# podman run hello-world
<!-- VERIFY -->
```

### versions

```shell
root@podman-5-4-0:~# podman version
<!-- VERIFY -->
root@podman-5-4-0:~# crun --version
<!-- VERIFY -->
root@podman-5-4-0:~# cat /etc/os-release
<!-- VERIFY -->
root@podman-5-4-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=podman/v5.4.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v5.4.0:ctr_v0.1.0
```
