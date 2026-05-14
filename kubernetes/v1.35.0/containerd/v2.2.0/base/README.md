# kubernetes v1.35.0 with containerd v2.2.0 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.35.0/containerd/v2.2.0/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.35.0_containerd-v2.2.0_base:ctr_v0.1.0
```
