# nerdctl v1.3.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.3.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.3.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v1.3.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v1.3.0:ctr_v0.1.0 | based on dqd `containerd-v1.7.0:ctr_v0.1.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v1.3.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v1.3.0
$ ssh dqd-nerdctl-v1.3.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v1.3.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-1-3-0:~# nerdctl run hello-world
<!-- VERIFY -->
root@nerdctl-1-3-0:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-1-3-0:~# nerdctl build -t foo .
root@nerdctl-1-3-0:~# nerdctl images
<!-- VERIFY -->
```

### versions

```shell
root@nerdctl-1-3-0:~# nerdctl --version
<!-- VERIFY -->
root@nerdctl-1-3-0:~# buildkitd --version
<!-- VERIFY -->
root@nerdctl-1-3-0:~# containerd --version
<!-- VERIFY -->
root@nerdctl-1-3-0:~# runc --version
<!-- VERIFY -->
root@nerdctl-1-3-0:~# cat /etc/os-release
<!-- VERIFY -->
root@nerdctl-1-3-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nerdctl/v1.3.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v1.3.0:ctr_v0.1.0
```
