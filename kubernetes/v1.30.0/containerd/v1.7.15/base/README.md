# Kubernetes v1.30.0 Base (containerd v1.7.15)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.30.0_containerd-v1.7.15_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.30.0_containerd-v1.7.15_base:v0.1.0 | migrate from docker_archive |

## build

```shell
make ctr ENV=kubernetes/v1.30.0/containerd/v1.7.15/base
```
