# Kubernetes v1.31.0 Base (containerd v1.7.18)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.31.0_containerd-v1.7.18_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.31.0_containerd-v1.7.18_base:v0.1.0 | migrate from docker_archive |

## build

```shell
make ctr ENV=kubernetes/v1.31.0/containerd/v1.7.18/base
```
