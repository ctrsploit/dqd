# kubernetes v1.32.4 with containerd v2.0.4, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.32.4_containerd-v2.0.4-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.32.4_containerd-v2.0.4-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.32.4/containerd/v2.0.4/calico/default
$ ssh dqd-kubernetes-v1.32.4_containerd-v2.0.4_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.32.4/containerd/v2.0.4/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-32-4-containerd-2-0-4:~# kubectl get pods -A
<!-- VERIFY -->
```

### Deploy a pod

```shell
root@kubernetes-1-32-4-containerd-2-0-4:~# kubectl run --image=docker.io/library/nginx:latest nginx
<!-- VERIFY -->
root@kubernetes-1-32-4-containerd-2-0-4:~# kubectl get pods
<!-- VERIFY -->
```

### versions

```shell
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
make all ENV=kubernetes/v1.32.4/containerd/v2.0.4/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_calico:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
