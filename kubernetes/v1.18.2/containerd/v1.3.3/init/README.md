# Kubernetes v1.18.2 Init (containerd v1.3.3)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_init:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_init:v0.1.0 | migrate from docker_archive |

## usage

```shell
$ dqd up kubernetes/v1.18.2/containerd/v1.3.3/init
$ ssh dqd-kubernetes-v1.18.2-containerd-v1.3.3-init
```

### Deploy a pod

```shell
root@kubernetes-1-18-2-containerd-1-3-3:~# kubectl get nodes
<!-- VERIFY -->
root@kubernetes-1-18-2-containerd-1-3-3:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-18-2-containerd-1-3-3:~# kubectl version --client
<!-- VERIFY -->
root@kubernetes-1-18-2-containerd-1-3-3:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-18-2-containerd-1-3-3:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.18.2/containerd/v1.3.3/init
```
