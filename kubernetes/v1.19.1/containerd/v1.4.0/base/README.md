# Kubernetes v1.19.1 Base (containerd v1.4.0)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.19.1_containerd-v1.4.0_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.19.1_containerd-v1.4.0_base:v0.1.0 | migrate from docker_archive |

## build

```shell
make ctr ENV=kubernetes/v1.19.1/containerd/v1.4.0/base
```
