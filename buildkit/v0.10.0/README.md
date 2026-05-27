# buildkit v0.10.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.10.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.10.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:buildkit-v0.10.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.10.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_buildkit-v0.10.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.10.0
$ ssh dqd-buildkit-v0.10.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.10.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-10-0:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-10-0:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 60B done
#1 DONE 0.1s

#2 [internal] load .dockerignore
#2 transferring context: 2B done
#2 DONE 0.0s

#3 [internal] load metadata for docker.io/library/ubuntu:latest
#3 DONE 8.7s

#4 [1/2] FROM docker.io/library/ubuntu@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9
...
#4 DONE 11.2s

#5 [2/2] RUN echo 1
#5 0.084 1
#5 DONE 0.3s
```

### versions

```shell
root@buildkit-0-10-0:~# buildkitd --version
<!-- VERIFY -->
root@buildkit-0-10-0:~# runc --version
<!-- VERIFY -->
root@buildkit-0-10-0:~# cat /etc/os-release
<!-- VERIFY -->
root@buildkit-0-10-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=buildkit/v0.10.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.10.0:ctr_v0.1.0
```
