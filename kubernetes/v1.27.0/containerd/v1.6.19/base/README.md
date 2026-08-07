# Kubernetes v1.27.0 Base (containerd v1.6.19)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.27.0_containerd-v1.6.19_base:v0.1.0 | migrate from docker_archive |

## build

```shell
make ctr ENV=kubernetes/v1.27.0/containerd/v1.6.19/base
```
