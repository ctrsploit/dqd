# kubernetes v1.33.8 with containerd v2.2.1 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.33.8/containerd/v2.2.1/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_base:ctr_v0.1.0
```
