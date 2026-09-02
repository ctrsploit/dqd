# kubernetes v1.36.4 with containerd v2.3.1 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.1_base:ctr_v0.1.0 | - |

## build

```shell
make ctr ENV=kubernetes/v1.36.4/containerd/v2.3.1/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.1_base:ctr_v0.1.0
```
