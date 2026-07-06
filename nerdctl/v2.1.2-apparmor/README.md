# nerdctl v2.1.2 with AppArmor

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.1.2-apparmor:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.1.2-apparmor:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v2.1.2-apparmor_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v2.1.2-apparmor:ctr_v0.1.0 | based on dqd `nerdctl-v2.1.2:ctr_v0.1.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v2.1.2-apparmor_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v2.1.2-apparmor
$ ssh dqd-nerdctl-v2.1.2-apparmor
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v2.1.2-apparmor
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl under AppArmor

```shell
root@nerdctl-2-1-2-apparmor:~# nerdctl run -ti busybox cat /proc/self/attr/current
<!-- VERIFY -->
root@nerdctl-2-1-2-apparmor:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-2-1-2-apparmor:~# nerdctl build -t foo .
root@nerdctl-2-1-2-apparmor:~# nerdctl images
<!-- VERIFY -->
```

### versions

```shell
root@nerdctl-2-1-2-apparmor:~# nerdctl --version
<!-- VERIFY -->
root@nerdctl-2-1-2-apparmor:~# buildkitd --version
<!-- VERIFY -->
root@nerdctl-2-1-2-apparmor:~# containerd --version
<!-- VERIFY -->
root@nerdctl-2-1-2-apparmor:~# runc --version
<!-- VERIFY -->
root@nerdctl-2-1-2-apparmor:~# cat /etc/os-release
<!-- VERIFY -->
root@nerdctl-2-1-2-apparmor:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nerdctl/v2.1.2-apparmor
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v2.1.2-apparmor:ctr_v0.1.0
```
