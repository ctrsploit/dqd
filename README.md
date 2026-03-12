# dqd: images of container's components

## Images

### ubuntu

| tag | version |
|-----|---------|
| [ubuntu-24.04](./ubuntu/24.04/) | v0.4.0  |

### runc

| tag | version |
|-----|---------|
| [runc-v1.3.4](./runc/v1.3.4/) | v0.2.0 |
| [runc-v1.2.5](./runc/v1.2.5/) | v0.4.0 |

### containerd

| tag | version |
|-----|---------|
| [containerd-v2.2.1](./containerd/v2.0.3/) | v0.2.0  |
| [containerd-v2.0.3](./containerd/v2.0.3/) | v0.4.0  |

### kubenertes

#### v1.35.1

| tag | version | alias | note |
|-----|---------|-------|------|
| [kubernetes-v1.35.1_containerd-v2.2.1_calico_debug](./kubernetes/v1.35.1/containerd/v2.2.1/calico/debug) | v0.1.0  | - | debug kubelet |
| [kubernetes-v1.35.1_containerd-v2.2.1_calico](./kubernetes/v1.35.1/containerd/v2.2.1/calico/default) | v0.1.0  | - | calico installed |
| [kubernetes-v1.35.1_containerd-v2.2.1_init](./kubernetes/v1.35.1/containerd/v2.2.1/init) | v0.1.0  | - | kubeadm init, without CNI |
| [kubernetes-v1.35.1_containerd-v2.2.1_base](./kubernetes/v1.35.1/containerd/v2.2.1/base) | v0.1.0  | - | k8s components installed  |

#### v1.32.2

| [kubernetes-v1.32.2_containerd-v2.0.3_calico_debug](./kubernetes/v1.32.2/containerd/v2.0.3/calico/debug) | v0.2.0  | - | debug kubelet,containerd |
| [kubernetes-v1.32.2_containerd-v2.0.3_calico](./kubernetes/v1.32.2/containerd/v2.0.3/calico/default) | v0.2.0  | - | calico installed  |
| [kubernetes-v1.32.2_containerd-v2.0.3_init](./kubernetes/v1.32.2/containerd/v2.0.3/init) | v0.3.0  | - | kubeadm init, without CNI  |
| [kubernetes-v1.32.2_containerd-v2.0.3_base](./kubernetes/v1.32.2/containerd/v2.0.3/base) | v0.3.0  | - | k8s components installed  |
 