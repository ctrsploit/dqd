# Kubernetes v1.25.0 Base (containerd v1.6.7)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.25.0_containerd-v1.6.7_base:v0.1.0 | migrate from docker_archive |

## build

```shell
make ctr ENV=kubernetes/v1.25.0/containerd/v1.6.7/base
```
