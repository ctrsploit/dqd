# kubernetes v1.36.4 with containerd v2.3.2 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_base:ctr_v0.1.1 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_base:ctr_v0.1.0 | wrong IMAGE name in .env (published as kubernetes-1-36-4-containerd-2-3-2-base, unused) |

## build

```shell
make ctr ENV=kubernetes/v1.36.4/containerd/v2.3.2/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_base:ctr_v0.1.1
```
