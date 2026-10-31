# buildx v0.38.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildx-v0.38.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildx-v0.38.1:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildx-v0.38.1:ctr_v0.1.0 | - |

buildx CLI plugin v0.38.1 on top of Docker Engine 29.7.2 (base: `docker-v29.7.2:ctr_v0.1.0`, Ubuntu 24.04).
Docker runs inside the VM; `docker build` goes through BuildKit. No host Docker socket is used.

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildx/v0.38.1
$ ssh dqd-buildx-v0.38.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildx/v0.38.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with docker build

```shell
root@buildx-0-38-1:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildx-0-38-1:~# docker build -t buildx-demo .
<!-- VERIFY -->
root@buildx-0-38-1:~# docker images buildx-demo
<!-- VERIFY -->
```

### versions

```shell
root@buildx-0-38-1:~# docker buildx version
<!-- VERIFY -->
root@buildx-0-38-1:~# docker version --format '{{.Server.Version}}'
<!-- VERIFY -->
root@buildx-0-38-1:~# cat /etc/os-release
<!-- VERIFY -->
root@buildx-0-38-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=buildx/v0.38.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildx-v0.38.1:ctr_v0.1.0
```
