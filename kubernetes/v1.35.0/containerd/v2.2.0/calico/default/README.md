# kubernetes v1.35.0 with containerd v2.2.0, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.35.0/containerd/v2.2.0/calico/default
$ ssh dqd-kubernetes-v1.35.0_containerd-v2.2.0_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.35.0/containerd/v2.2.0/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
<!-- VERIFY -->
```

### run a container

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
<!-- VERIFY -->
$ kubectl --kubeconfig=kubeconfig get pods
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-35-0-containerd-2-2-0:~# helm version
<!-- VERIFY -->
root@kubernetes-1-35-0-containerd-2-2-0:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-35-0-containerd-2-2-0:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-35-0-containerd-2-2-0:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-35-0-containerd-2-2-0:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-35-0-containerd-2-2-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.35.0/containerd/v2.2.0/calico/default
```


### for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_calico:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
