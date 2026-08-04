# Kubernetes v1.24.0 Base (containerd v1.6.4)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.24.0_containerd-v1.6.4_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.24.0_containerd-v1.6.4_base:v0.1.0 | migrate from docker_archive |

## build

```shell
make ctr ENV=kubernetes/v1.24.0/containerd/v1.6.4/base
```
