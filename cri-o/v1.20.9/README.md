# cri-o v1.20.9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/cri-o-v1.20.9:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/cri-o-v1.20.9:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/cri-o-v1.20.9:ctr_v0.1.0 | cri-o official static bundle on Ubuntu 20.04 |

## usage

### Start and connect

Recommended:

```shell
$ dqd up cri-o/v1.20.9
$ ssh dqd-cri-o-v1.20.9
```

Fallback without dqd CLI or SSH config:

```shell
$ cd cri-o/v1.20.9
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@cri-o-1-20-9:~# crictl pull docker.io/library/busybox
<!-- VERIFY -->
root@cri-o-1-20-9:~# crictl runp /root/pod.json
<!-- VERIFY -->
root@cri-o-1-20-9:~# crictl create $(crictl pods -q) /root/container.json /root/pod.json
<!-- VERIFY -->
root@cri-o-1-20-9:~# crictl start $(crictl ps -q --state created)
<!-- VERIFY -->
root@cri-o-1-20-9:~# crictl ps
<!-- VERIFY -->
```

### versions

```shell
root@cri-o-1-20-9:~# crio --version
<!-- VERIFY -->
root@cri-o-1-20-9:~# runc --version
<!-- VERIFY -->
root@cri-o-1-20-9:~# cat /etc/os-release
<!-- VERIFY -->
root@cri-o-1-20-9:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=cri-o/v1.20.9
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/cri-o-v1.20.9:ctr_v0.1.0
```
