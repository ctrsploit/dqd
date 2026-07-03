# podman v5.5.1 debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v5.5.1-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v5.5.1-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:podman-v5.5.1-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/podman-v5.5.1-debug:ctr_v0.1.0 | add podman debug binary and dlv |
| ctr | ssst0n3/docker_archive:ctr_podman-v5.5.1-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v5.5.1-debug
$ ssh dqd-podman-v5.5.1-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v5.5.1-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug podman with dlv

| Component | Host port |
| --------- | --------- |
| podman | 55102 |

```shell
root@podman-5-5-1-debug:~# ln -sf /usr/local/bin/debug.sh /usr/bin/podman
root@podman-5-5-1-debug:~# timeout 5 podman run -u nobody -ti --cap-add CAP_DAC_OVERRIDE ubuntu bash
<!-- VERIFY -->
```

### versions

```shell
root@podman-5-5-1-debug:~# /root/bin/podman.real version
<!-- VERIFY -->
root@podman-5-5-1-debug:~# /root/bin/podman.debug version
<!-- VERIFY -->
root@podman-5-5-1-debug:~# dlv version
<!-- VERIFY -->
root@podman-5-5-1-debug:~# crun --version
<!-- VERIFY -->
root@podman-5-5-1-debug:~# cat /etc/os-release
<!-- VERIFY -->
root@podman-5-5-1-debug:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=podman/v5.5.1-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v5.5.1-debug:ctr_v0.1.0
```
