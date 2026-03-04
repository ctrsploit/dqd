# kubernetes v1.32.2 with containerd v2.0.3 base image

* ctr:
  * ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_base:ctr_v0.2.0
  * ssst0n3/docker_archive:ctr_kubernetes-v1.32.2_containerd-v2.0.3-base_v0.1.0

## build

```shell
make ctr DIR=kubernetes/v1.32.2/containerd/v2.0.3/base
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_base:ctr_v0.2.0
```
