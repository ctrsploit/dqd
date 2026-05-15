# kubernetes v1.33.7 with containerd v2.1.5 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.7_containerd-v2.1.5_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.33.7/containerd/v2.1.5/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.33.7_containerd-v2.1.5_base:ctr_v0.1.0
```
