# kubernetes v1.33.1 with containerd v2.1.0 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.33.1/containerd/v2.1.0/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_base:ctr_v0.1.0
```
