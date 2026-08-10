# Kubernetes v1.29.0 Base (containerd v1.7.1)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.29.0_containerd-v1.7.1_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.29.0_containerd-v1.7.1_base:v0.1.0 | migrate from docker_archive |

## build

```shell
make ctr ENV=kubernetes/v1.29.0/containerd/v1.7.1/base
```
