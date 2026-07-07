# nerdctl v1.7.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.7.4:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v1.7.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v1.7.4_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v1.7.4:ctr_v0.1.0 | based on dqd `containerd-v1.7.13:ctr_v0.1.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v1.7.4_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v1.7.4
$ ssh dqd-nerdctl-v1.7.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v1.7.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-1-7-4:~# nerdctl run hello-world
<!-- VERIFY -->
root@nerdctl-1-7-4:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-1-7-4:~# nerdctl build -t foo .
root@nerdctl-1-7-4:~# nerdctl images
<!-- VERIFY -->
```

### versions

```shell
root@nerdctl-1-7-4:~# nerdctl --version
<!-- VERIFY -->
root@nerdctl-1-7-4:~# buildkitd --version
<!-- VERIFY -->
root@nerdctl-1-7-4:~# containerd --version
<!-- VERIFY -->
root@nerdctl-1-7-4:~# runc --version
<!-- VERIFY -->
root@nerdctl-1-7-4:~# cat /etc/os-release
<!-- VERIFY -->
root@nerdctl-1-7-4:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nerdctl/v1.7.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v1.7.4:ctr_v0.1.0
```
