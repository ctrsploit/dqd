# kubernetes v1.33.4 with containerd v2.1.4 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.33.4/containerd/v2.1.4/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.33.4_containerd-v2.1.4_base:ctr_v0.1.0
```
