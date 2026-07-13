# kubernetes v1.34.0 with containerd v2.1.4

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_init:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_init:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_init:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.34.0/containerd/v2.1.4/init
$ ssh dqd-kubernetes-v1.34.0_containerd-v2.1.4_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.34.0/containerd/v2.1.4/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-34-0-containerd-2-1-4:~# helm version
<!-- VERIFY -->
root@kubernetes-1-34-0-containerd-2-1-4:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-34-0-containerd-2-1-4:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-34-0-containerd-2-1-4:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-34-0-containerd-2-1-4:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-34-0-containerd-2-1-4:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.34.0/containerd/v2.1.4/init
```


## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_base:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug

## Notes

This base image uses the **fuse-overlayfs** containerd snapshotter, so there is no
overlayfs-on-overlayfs problem during build. kubeadm init therefore runs directly
under `/sbin/init` (no snapshot cache mount), unlike the overlayfs-based
v1.32.x / v1.35.x bases which need the snapshot cache trick.
