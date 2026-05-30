# docker v19.03.13 debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v19.03.13-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v19.03.13-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v19.03.13-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v19.03.13-debug:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v19.03.13-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v19.03.13-debug
$ ssh dqd-docker-v19.03.13-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v19.03.13-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### debug-ports

| Port | Component |
|------|-----------|
| 19311 | runc main |
| 19312 | runc init |
| 19313 | dockerd |
| 19314 | docker (reserved) |
| 19315 | containerd |
| 19316 | containerd-shim |
| 19317 | containerd-shim-runc-v1 |
| 19328 | containerd-shim-runc-v2 |
| 19329 | ctr |

### containerd debug

```shell
root@docker-19-03-13-debug:~# systemctl stop containerd
root@docker-19-03-13-debug:~# ln -sf /usr/local/bin/debug.sh /usr/bin/containerd
root@docker-19-03-13-debug:~# ln -sf /usr/local/bin/debug.sh /usr/bin/containerd-shim
root@docker-19-03-13-debug:~# containerd -c /etc/containerd/config.toml -l debug
API server listening at: [::]:2345
```

### docker debug

```shell
root@docker-19-03-13-debug:~# systemctl stop docker
root@docker-19-03-13-debug:~# ln -sf /usr/local/bin/debug.sh /usr/bin/dockerd
root@docker-19-03-13-debug:~# dockerd -D
API server listening at: [::]:2343
```

### runc debug

```shell
root@docker-19-03-13-debug:~# ln -sf /usr/local/bin/debug.sh /usr/bin/runc
root@docker-19-03-13-debug:~# ps -ef |grep runc |grep init
root@docker-19-03-13-debug:~# attach.sh [PID]
```

### versions

```shell
root@docker-19-03-13-debug:~# docker version
<!-- VERIFY -->
root@docker-19-03-13-debug:~# cat /etc/os-release
<!-- VERIFY -->
root@docker-19-03-13-debug:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=docker/v19.03.13-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v19.03.13-debug:ctr_v0.1.0
```
