# dqd: images of container's components

[docker_archive](https://github.com/ssst0n3/docker_archive) is being migrated here. For older images, please refer to the previous docker_archive project.

## Runtime Setup

The `dqd` CLI is for operating existing environments only. Build and development workflows stay in `Makefile`.

### Install

```bash
script/install_cli.sh
script/install_ssh_config.sh
export PATH="$HOME/.local/bin:$PATH"
```

Run the install commands once from the repository root. `script/install_cli.sh` links `dqd` into `~/.local/bin`, and `script/install_ssh_config.sh` copies the dqd SSH keys into `~/.ssh/keys` and adds this repository's `ssh_config/config` as an `Include` in `~/.ssh/config`.

If your shell does not pick up `dqd` immediately, run `rehash` or open a new shell.

### Start And Connect

```bash
dqd list
dqd ps
dqd ps vul
dqd info runc/v1.3.0
dqd up runc/v1.3.0
ssh dqd-runc-v1.3.0
dqd down runc/v1.3.0
```

SSH aliases use the image name from each environment's `.env` with a `dqd-` prefix. For example, `runc/v1.3.0` uses `ssh dqd-runc-v1.3.0`.

### KVM Mode

`dqd up` automatically uses `docker-compose.kvm.yml` when `/dev/kvm` exists and the environment has a KVM overlay. Use `--kvm=false` when you need to force non-KVM startup:

```bash
dqd up runc/v1.3.0 --kvm=false
```

## Images

### vul

| tag | version |
|-----|---------|
| [cve-2026-43284](./vul/cve-2026-43284/) | v0.3.0 |
| [cve-2026-31431](./vul/cve-2026-31431/) | v0.3.0 |
| [cve-2022-0847](./vul/cve-2022-0847/) | v0.3.0 |
| [cve-2026-43500](./vul/cve-2026-43500/) | v0.1.0 |

### ubuntu

| tag | version |
|-----|---------|
| [ubuntu-12.04](./ubuntu/12.04/) | v0.2.0  |
| [ubuntu-14.04](./ubuntu/14.04/) | v0.2.0  |
| [ubuntu-16.04](./ubuntu/16.04/) | v0.3.0  |
| [ubuntu-18.04](./ubuntu/18.04/) | v0.3.0  |
| [ubuntu-20.04](./ubuntu/20.04/) | v0.3.0  |
| [ubuntu-22.04](./ubuntu/22.04/) | v0.3.0  |
| [ubuntu-22.04-dbg](./ubuntu/22.04-dbg/) | v0.2.0  |
| [ubuntu-24.04](./ubuntu/24.04/) | v0.4.0  |

### debian

| tag | version |
|-----|---------|
| [debian-11.0](./debian/11.0/) | v0.1.0  |
| [debian-12.0](./debian/12.0/) | v0.2.0  |

### centos

| tag | version |
|-----|---------|
| [centos-8](./centos/8/) | v0.2.0  |
| [centos-stream9](./centos/stream9/) | v0.2.0  |

### runc

| tag | version |
|-----|---------|
| [runc-v1.3.5](./runc/v1.3.5/) | v0.1.0 |
| [runc-v1.3.4](./runc/v1.3.4/) | v0.2.0 |
| [runc-v1.3.3](./runc/v1.3.3/) | v0.2.0 |
| [runc-v1.3.0](./runc/v1.3.0/) | v0.2.0 |
| [runc-v1.2.5](./runc/v1.2.5/) | v0.4.0 |
| [runc-v0.0.2.1](./runc/v0.0.2.1/) | v0.3.0 |
| [runc-v0.0.5](./runc/v0.0.5/) | v0.3.0 |
| [runc-v0.0.4](./runc/v0.0.4/) | v0.3.0 |
| [runc-v0.0.3](./runc/v0.0.3/) | v0.3.0 |
| [runc-v0.0.2](./runc/v0.0.2/) | v0.3.0 |
| [runc-v0.0.1](./runc/v0.0.1/) | v0.3.0 |

### containerd

| tag | version |
|-----|---------|
| [containerd-v2.2.3](./containerd/v2.2.3/) | v0.1.0  |
| [containerd-v2.2.1](./containerd/v2.2.1/) | v0.2.0  |
| [containerd-v2.2.0](./containerd/v2.2.0/) | v0.2.0  |
| [containerd-v2.1.4](./containerd/v2.1.4/) | v0.2.0  |
| [containerd-v2.1.1](./containerd/v2.1.1/) | v0.2.0  |
| [containerd-v2.0.4](./containerd/v2.0.4/) | v0.3.0  |
| [containerd-v2.0.3](./containerd/v2.0.3/) | v0.4.0  |

### docker

| tag | version |
|-----|---------|
| [docker-v20.10.12](./docker/v20.10.12/) | v0.2.0  |
| [docker-v29.4.1](./docker/v29.4.1/) | v0.2.0  |

### kubenertes

#### v1.35.1

| tag | version | alias | note |
|-----|---------|-------|------|
| [kubernetes-v1.35.1_containerd-v2.2.1_calico_debug](./kubernetes/v1.35.1/containerd/v2.2.1/calico/debug) | v0.2.0  | - | debug kubelet,containerd |
| [kubernetes-v1.35.1_containerd-v2.2.1_calico](./kubernetes/v1.35.1/containerd/v2.2.1/calico/default) | v0.1.0  | - | calico installed |
| [kubernetes-v1.35.1_containerd-v2.2.1_init](./kubernetes/v1.35.1/containerd/v2.2.1/init) | v0.1.0  | - | kubeadm init, without CNI |
| [kubernetes-v1.35.1_containerd-v2.2.1_base](./kubernetes/v1.35.1/containerd/v2.2.1/base) | v0.1.0  | - | k8s components installed  |

#### v1.35.0

| tag | version | alias | note |
|-----|---------|-------|------|
| [kubernetes-v1.35.0_containerd-v2.2.0_base](./kubernetes/v1.35.0/containerd/v2.2.0/base) | v0.1.0  | - | k8s components installed  |

#### v1.34.0

| tag | version | alias | note |
|-----|---------|-------|------|
| [kubernetes-v1.34.0_containerd-v2.1.4_base](./kubernetes/v1.34.0/containerd/v2.1.4/base) | v0.1.0  | - | k8s components installed  |

#### v1.32.2

| tag | version | alias | note |
|-----|---------|-------|------|
| [kubernetes-v1.32.2_containerd-v2.0.4_init](./kubernetes/v1.32.2/containerd/v2.0.4/init) | v0.1.0  | - | kubeadm init, without CNI |
| [kubernetes-v1.32.2_containerd-v2.0.4_base](./kubernetes/v1.32.2/containerd/v2.0.4/base) | v0.1.0  | - | k8s components installed  |
| [kubernetes-v1.32.2_containerd-v2.0.3_calico_debug](./kubernetes/v1.32.2/containerd/v2.0.3/calico/debug) | v0.2.0  | - | debug kubelet,containerd |
| [kubernetes-v1.32.2_containerd-v2.0.3_calico](./kubernetes/v1.32.2/containerd/v2.0.3/calico/default) | v0.2.0  | - | calico installed  |
| [kubernetes-v1.32.2_containerd-v2.0.3_init](./kubernetes/v1.32.2/containerd/v2.0.3/init) | v0.3.0  | - | kubeadm init, without CNI  |
| [kubernetes-v1.32.2_containerd-v2.0.3_base](./kubernetes/v1.32.2/containerd/v2.0.3/base) | v0.3.0  | - | k8s components installed  |
