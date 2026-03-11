# kubernetes v1.35.1 with containerd v2.2.1 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.35.1_containerd-v2.2.1_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.35.1/containerd/v2.2.1/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.35.1_containerd-v2.2.1_base:ctr_v0.1.0
```
