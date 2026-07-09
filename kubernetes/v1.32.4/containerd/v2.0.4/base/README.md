# kubernetes v1.32.4 with containerd v2.0.4 base image

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_base:ctr_v0.1.0 | migrate from docker_archive |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.32.4_containerd-v2.0.4-base_v0.1.0 | source |

## build

```shell
make ctr ENV=kubernetes/v1.32.4/containerd/v2.0.4/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.32.4_containerd-v2.0.4_base:ctr_v0.1.0
```
