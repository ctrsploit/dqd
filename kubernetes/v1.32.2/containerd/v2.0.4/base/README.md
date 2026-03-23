# kubernetes v1.32.2 with containerd v2.0.4 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.4_base:ctr_v0.1.0 |

## build

```shell
make ctr ENV=kubernetes/v1.32.2/containerd/v2.0.4/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.4_base:ctr_v0.1.0
```
