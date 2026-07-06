# nerdctl v2.1.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.1.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.1.2:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v2.1.2_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v2.1.2:ctr_v0.1.0 | based on dqd `containerd-v2.1.1:ctr_v0.2.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v2.1.2_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v2.1.2
$ ssh dqd-nerdctl-v2.1.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v2.1.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-2-1-2:~# nerdctl run hello-world
<!-- VERIFY -->
root@nerdctl-2-1-2:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-2-1-2:~# nerdctl build -t foo .
root@nerdctl-2-1-2:~# nerdctl images
<!-- VERIFY -->
```

### versions

```shell
root@nerdctl-2-1-2:~# nerdctl --version
<!-- VERIFY -->
root@nerdctl-2-1-2:~# buildkitd --version
<!-- VERIFY -->
root@nerdctl-2-1-2:~# containerd --version
<!-- VERIFY -->
root@nerdctl-2-1-2:~# runc --version
<!-- VERIFY -->
root@nerdctl-2-1-2:~# cat /etc/os-release
<!-- VERIFY -->
root@nerdctl-2-1-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nerdctl/v2.1.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v2.1.2:ctr_v0.1.0
```
