# buildkit v0.34.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.34.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.34.1:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.34.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.34.1
$ ssh dqd-buildkit-v0.34.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.34.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-34-1:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-34-1:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
<!-- VERIFY -->
```

### versions

```shell
root@buildkit-0-34-1:~# buildkitd --version
<!-- VERIFY -->
root@buildkit-0-34-1:~# runc --version
<!-- VERIFY -->
root@buildkit-0-34-1:~# cat /etc/os-release
<!-- VERIFY -->
root@buildkit-0-34-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=buildkit/v0.34.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.34.1:ctr_v0.1.0
```
