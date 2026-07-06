# nerdctl v2.0.4 with runc v1.2.5 debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.0.4_runc-v1.2.5-debug:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v2.0.4_runc-v1.2.5-debug:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v2.0.4_runc-v1.2.5-debug_v0.2.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v2.0.4_runc-v1.2.5-debug:ctr_v0.2.0 | based on dqd `containerd-v2.0.4:ctr_v0.3.0` |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v2.0.4_v0.2.0 | original nerdctl base |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v2.0.4_runc-v1.2.5-debug
$ ssh dqd-nerdctl-v2.0.4_runc-v1.2.5-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v2.0.4_runc-v1.2.5-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug ports

| Port | Component |
| ---- | --------- |
| 20406 | runc (dlv) |
| 20407 | runc init attach |

### Debug runc with nerdctl

```shell
root@nerdctl-2-0-4-runc-1-2-5-debug:~# ln -sf /root/runc.debug /usr/local/sbin/runc
root@nerdctl-2-0-4-runc-1-2-5-debug:~# runc --version
<!-- VERIFY -->
```

Use `attach.sh <pid>` to attach dlv to a running runc init process.

### Run a container with nerdctl

```shell
root@nerdctl-2-0-4-runc-1-2-5-debug:~# nerdctl run hello-world
<!-- VERIFY -->
root@nerdctl-2-0-4-runc-1-2-5-debug:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-2-0-4-runc-1-2-5-debug:~# nerdctl build -t foo .
root@nerdctl-2-0-4-runc-1-2-5-debug:~# nerdctl images
<!-- VERIFY -->
```

### versions

```shell
root@nerdctl-2-0-4-runc-1-2-5-debug:~# ln -sf /root/runc.real /usr/local/sbin/runc
root@nerdctl-2-0-4-runc-1-2-5-debug:~# nerdctl --version
<!-- VERIFY -->
root@nerdctl-2-0-4-runc-1-2-5-debug:~# buildkitd --version
<!-- VERIFY -->
root@nerdctl-2-0-4-runc-1-2-5-debug:~# containerd --version
<!-- VERIFY -->
root@nerdctl-2-0-4-runc-1-2-5-debug:~# runc --version
<!-- VERIFY -->
root@nerdctl-2-0-4-runc-1-2-5-debug:~# cat /etc/os-release
<!-- VERIFY -->
root@nerdctl-2-0-4-runc-1-2-5-debug:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nerdctl/v2.0.4_runc-v1.2.5-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v2.0.4_runc-v1.2.5-debug:ctr_v0.2.0
```
