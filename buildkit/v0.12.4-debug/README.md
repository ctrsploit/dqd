# buildkit v0.12.4 debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.12.4-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.12.4-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:buildkit-v0.12.4-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.12.4-debug:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_buildkit-v0.12.4-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.12.4-debug
$ ssh dqd-buildkit-v0.12.4-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.12.4-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug buildkitd with dlv

```shell
root@buildkit-0-12-4-debug:~# systemctl stop buildkit
Stopping 'buildkit.service', but its triggering units are still active:
buildkit.socket
root@buildkit-0-12-4-debug:~# ln -sf /usr/local/bin/debug.sh /usr/local/bin/buildkitd
root@buildkit-0-12-4-debug:~# buildkitd
API server listening at: [::]:2345
2025-08-26T03:02:50Z warning layer=rpc Listening for remote connections (connections are not authenticated nor encrypted)
```

### Build images with buildctl

```shell
root@buildkit-0-12-4-debug:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-12-4-debug:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
<!-- VERIFY -->
```

### versions

```shell
root@buildkit-0-12-4-debug:~# buildkitd --version
<!-- VERIFY -->
root@buildkit-0-12-4-debug:~# runc --version
<!-- VERIFY -->
root@buildkit-0-12-4-debug:~# cat /etc/os-release
<!-- VERIFY -->
root@buildkit-0-12-4-debug:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=buildkit/v0.12.4-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.12.4-debug:ctr_v0.1.0
```
