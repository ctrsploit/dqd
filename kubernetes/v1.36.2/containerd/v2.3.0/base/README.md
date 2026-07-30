# kubernetes v1.36.2 with containerd v2.3.0 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.2_containerd-v2.3.0_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.36.2/containerd/v2.3.0/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.36.2_containerd-v2.3.0_base:ctr_v0.1.0
```
