# Kubernetes v1.21.1 Base (containerd v1.5.1)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.21.1_containerd-v1.5.1_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.21.1_containerd-v1.5.1_base:v0.1.0 | migrate from docker_archive |

## build

```shell
make ctr ENV=kubernetes/v1.21.1/containerd/v1.5.1/base
```
