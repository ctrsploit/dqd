# Kubernetes v1.21.1 Base (containerd v1.5.2)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.21.1_containerd-v1.5.2_base:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.21.1_containerd-v1.5.2_base:v0.1.0 | containerd 1.5.2 pins runc 1.0.0-rc95 (fixed counterpart of CVE-2021-30465) |

## build

```shell
make ctr ENV=kubernetes/v1.21.1/containerd/v1.5.2/base
```
