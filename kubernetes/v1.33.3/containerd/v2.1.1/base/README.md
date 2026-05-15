# kubernetes v1.33.3 with containerd v2.1.1 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.1_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.33.3/containerd/v2.1.1/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.33.3_containerd-v2.1.1_base:ctr_v0.1.0
```
