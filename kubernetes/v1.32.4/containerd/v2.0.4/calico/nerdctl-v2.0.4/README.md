# kubernetes v1.32.4 with containerd v2.0.4, calico, nerdctl v2.0.4

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.32.4_containerd-v2.0.4-calico_nerdctl-v2.0.4_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.32.4_containerd-v2.0.4-calico_nerdctl-v2.0.4_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.32.4/containerd/v2.0.4/calico/nerdctl-v2.0.4
$ ssh dqd-kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.32.4/containerd/v2.0.4/calico/nerdctl-v2.0.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### nerdctl

```shell
root@kubernetes-1-32-4-containerd-2-0-4:~# nerdctl run hello-world
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# echo 'FROM hello-world' > Dockerfile
root@kubernetes-1-32-4-containerd-2-0-4:~# nerdctl build -t foo .
root@kubernetes-1-32-4-containerd-2-0-4:~# nerdctl images
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-32-4-containerd-2-0-4:~# nerdctl --version
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# buildkitd --version
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# helm version
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.32.4/containerd/v2.0.4/calico/nerdctl-v2.0.4
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico:ctr_v0.1.0
...
ADD https://github.com/containerd/nerdctl/releases/download/v2.0.4/nerdctl-2.0.4-linux-amd64.tar.gz /tmp/nerdctl.tar.gz
RUN tar Cxzvvf /usr/local/bin /tmp/nerdctl.tar.gz && rm /tmp/nerdctl.tar.gz
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
