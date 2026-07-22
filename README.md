# dqd: reproducible container runtime environments

[docker_archive](https://github.com/ssst0n3/docker_archive) is being migrated here. For older images, please refer to the previous docker_archive project.

## Runtime Setup

The `dqd` CLI is for operating existing environments only. Build and development workflows stay in `Makefile`.

### Install

```bash
git clone git@github.com:ctrsploit/dqd.git
cd dqd
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

| image |
|-----|
| [cve-2026-46300](./vul/cve-2026-46300/) |
| [cve-2026-43284](./vul/cve-2026-43284/) |
| [cve-2026-31431](./vul/cve-2026-31431/) |
| [cve-2026-23111](./vul/cve-2026-23111/) |
| [cve-2026-23111-debian](./vul/cve-2026-23111-debian/) |
| [cve-2026-23111-fix](./vul/cve-2026-23111-fix/) |
| [cve-2025-23266-mitigation](./vul/cve-2025-23266-mitigation/) |
| [cve-2016-8867](./vul/cve-2016-8867/) |
| [cve-2019-5736](./vul/cve-2019-5736/) |
| [cve-2020-15257](./vul/cve-2020-15257/) |
| [cve-2022-0492](./vul/cve-2022-0492/) |
| [cve-2022-39253](./vul/cve-2022-39253/) |
| [cve-2024-0132](./vul/cve-2024-0132/) |
| [cve-2024-23650](./vul/cve-2024-23650/) |
| [cve-2025-47290](./vul/cve-2025-47290/) |
| [cve-2025-62725](./vul/cve-2025-62725/) |
| [shocker-v0.7.1](./vul/shocker/v0.7.1/) |
| [shocker-v0.7.2](./vul/shocker/v0.7.2/) |
| [shocker-v0.9.0](./vul/shocker/v0.9.0/) |
| [shocker-v0.9.0-lxc](./vul/shocker/v0.9.0-lxc/) |
| [shocker-v0.11.1](./vul/shocker/v0.11.1/) |
| [shocker-v0.11.1-lxc](./vul/shocker/v0.11.1-lxc/) |
| [shocker-v0.12.0](./vul/shocker/v0.12.0/) |
| [cve-2025-23266](./vul/cve-2025-23266/) |
| [cve-2022-0847](./vul/cve-2022-0847/) |
| [cve-2026-43500](./vul/cve-2026-43500/) |
| [cve-2026-24260](./vul/cve-2026-24260/) |

### ubuntu

| image |
|-----|
| [ubuntu-12.04](./ubuntu/12.04/) |
| [ubuntu-14.04](./ubuntu/14.04/) |
| [ubuntu-16.04](./ubuntu/16.04/) |
| [ubuntu-18.04](./ubuntu/18.04/) |
| [ubuntu-20.04](./ubuntu/20.04/) |
| [ubuntu-22.04](./ubuntu/22.04/) |
| [ubuntu-22.04-dbg](./ubuntu/22.04-dbg/) |
| [ubuntu-24.04](./ubuntu/24.04/) |

### debian

| image |
|-----|
| [debian-11.0](./debian/11.0/) |
| [debian-12.0](./debian/12.0/) |

### centos

| image |
|-----|
| [centos-8](./centos/8/) |
| [centos-stream9](./centos/stream9/) |

### ctf

| image |
|-----|
| [Be-a-Docker-Escaper](./ctf/Be-a-Docker-Escaper/) |
| [your-gpu-my-shell](./ctf/your-gpu-my-shell/) |

### runc

| image |
|-----|
| [runc-v1.4.2](./runc/v1.4.2/) |
| [runc-v1.4.2-kernel-v4.15](./runc/v1.4.2-kernel-v4.15/) |
| [runc-v1.3.5](./runc/v1.3.5/) |
| [runc-v1.3.4](./runc/v1.3.4/) |
| [runc-v1.3.3](./runc/v1.3.3/) |
| [runc-v1.3.0](./runc/v1.3.0/) |
| [runc-v1.3.0-rc.2](./runc/v1.3.0-rc.2/) |
| [runc-v1.3.0-rc.1](./runc/v1.3.0-rc.1/) |
| [runc-v1.2.5](./runc/v1.2.5/) |
| [runc-v1.2.6](./runc/v1.2.6/) |
| [runc-v1.2.4](./runc/v1.2.4/) |
| [runc-v1.2.3](./runc/v1.2.3/) |
| [runc-v1.2.2](./runc/v1.2.2/) |
| [runc-v1.2.1](./runc/v1.2.1/) |
| [runc-v1.2.0](./runc/v1.2.0/) |
| [runc-v1.2.0-rc.3](./runc/v1.2.0-rc.3/) |
| [runc-v1.2.0-rc.2](./runc/v1.2.0-rc.2/) |
| [runc-v1.2.0-rc.1](./runc/v1.2.0-rc.1/) |
| [runc-v1.1.12](./runc/v1.1.12/) |
| [runc-v1.1.13](./runc/v1.1.13/) |
| [runc-v1.1.14](./runc/v1.1.14/) |
| [runc-v1.1.15](./runc/v1.1.15/) |
| [runc-v1.1.11](./runc/v1.1.11/) |
| [runc-v1.1.10](./runc/v1.1.10/) |
| [runc-v1.1.9](./runc/v1.1.9/) |
| [runc-v1.1.8](./runc/v1.1.8/) |
| [runc-v1.1.7](./runc/v1.1.7/) |
| [runc-v1.1.6](./runc/v1.1.6/) |
| [runc-v1.1.5](./runc/v1.1.5/) |
| [runc-v1.1.4](./runc/v1.1.4/) |
| [runc-v1.1.3](./runc/v1.1.3/) |
| [runc-v1.1.2](./runc/v1.1.2/) |
| [runc-v1.1.1](./runc/v1.1.1/) |
| [runc-v1.1.0](./runc/v1.1.0/) |
| [runc-v1.1.0-rc.1](./runc/v1.1.0-rc.1/) |
| [runc-v1.0.3](./runc/v1.0.3/) |
| [runc-v1.0.2](./runc/v1.0.2/) |
| [runc-v1.0.0](./runc/v1.0.0/) |
| [runc-v1.0.1](./runc/v1.0.1/) |
| [runc-v1.0.0-rc95](./runc/v1.0.0-rc95/) |
| [runc-v1.0.0-rc94](./runc/v1.0.0-rc94/) |
| [runc-v1.0.0-rc93](./runc/v1.0.0-rc93/) |
| [runc-v1.0.0-rc92](./runc/v1.0.0-rc92/) |
| [runc-v1.0.0-rc91](./runc/v1.0.0-rc91/) |
| [runc-v1.0.0-rc90](./runc/v1.0.0-rc90/) |
| [runc-v1.0.0-rc10](./runc/v1.0.0-rc10/) |
| [runc-v1.0.0-rc9](./runc/v1.0.0-rc9/) |
| [runc-v1.0.0-rc8](./runc/v1.0.0-rc8/) |
| [runc-v1.0.0-rc7](./runc/v1.0.0-rc7/) |
| [runc-v1.0.0-rc6](./runc/v1.0.0-rc6/) |
| [runc-v1.0.0-rc5](./runc/v1.0.0-rc5/) |
| [runc-v1.0.0-rc4](./runc/v1.0.0-rc4/) |
| [runc-v1.0.0-rc3](./runc/v1.0.0-rc3/) |
| [runc-v1.0.0-rc3-dbg](./runc/v1.0.0-rc3-dbg/) |
| [runc-v1.0.0-rc2](./runc/v1.0.0-rc2/) |
| [runc-v1.0.0-rc2-dbg](./runc/v1.0.0-rc2-dbg/) |
| [runc-v1.0.0-rc1](./runc/v1.0.0-rc1/) |
| [runc-v0.1.1](./runc/v0.1.1/) |
| [runc-v0.1.0](./runc/v0.1.0/) |
| [runc-v0.0.9](./runc/v0.0.9/) |
| [runc-v0.0.8](./runc/v0.0.8/) |
| [runc-v0.0.7](./runc/v0.0.7/) |
| [runc-v0.0.6](./runc/v0.0.6/) |
| [runc-v0.0.5](./runc/v0.0.5/) |
| [runc-v0.0.4](./runc/v0.0.4/) |
| [runc-v0.0.3](./runc/v0.0.3/) |
| [runc-v0.0.2.1](./runc/v0.0.2.1/) |
| [runc-v0.0.2](./runc/v0.0.2/) |
| [runc-v1.1.9-ubuntu-20.04](./runc/ubuntu-20.04-v1.1.9/) |
| [runc-v1.2.0-centos-stream9](./runc/centos-stream9-v1.2.0/) |
| [runc-v1.3.0-rc.1-criu](./runc/v1.3.0-rc.1-criu/) |
| [runc-v1.3.0-rc.2-criu](./runc/v1.3.0-rc.2-criu/) |
| [runc-v1.2.6-debian-11.0](./runc/debian-11.0-v1.2.6/) |
| [runc-v1.2.6-debian-11.0-criu-v3.14](./runc/debian-11.0-v1.2.6-criu-v3.14/) |
| [runc-v1.2.0-centos-stream9-selinux](./runc/centos-stream9-v1.2.0-selinux/) |
| [runc-v1.3.0-rc.1-centos-stream9](./runc/centos-stream9-v1.3.0-rc.1/) |
| [runc-v1.3.0-rc.1-centos-stream9-selinux](./runc/centos-stream9-v1.3.0-rc.1-selinux/) |
| [runc-v1.3.0-rc.1-debian-11.0](./runc/debian-11.0-v1.3.0-rc.1/) |
| [runc-v1.3.0-rc.1-debian-11.0-criu-v3.14](./runc/debian-11.0-v1.3.0-rc.1-criu-v3.14/) |
| [runc-v1.1.0-7396ca9](./runc/v1.1.0-7396ca9/) |
| [runc-v1.1.0-7d09ba1](./runc/v1.1.0-7d09ba1/) |
| [runc-v1.1.0-a6f4081](./runc/v1.1.0-a6f4081/) |
| [runc-v1.1.0-ab3cd8d](./runc/v1.1.0-ab3cd8d/) |
| [runc-v1.1.0-d3d7f7d](./runc/v1.1.0-d3d7f7d/) |
| [runc-v0.0.1](./runc/v0.0.1/) |

### buildkit

| image |
|-----|
| [buildkit-v0.9.0](./buildkit/v0.9.0/) |
| [buildkit-v0.7.0](./buildkit/v0.7.0/) |
| [buildkit-v0.5.0](./buildkit/v0.5.0/) |
| [buildkit-v0.4.0](./buildkit/v0.4.0/) |
| [buildkit-v0.3.0](./buildkit/v0.3.0/) |
| [buildkit-v0.21.1](./buildkit/v0.21.1/) |
| [buildkit-v0.21.0](./buildkit/v0.21.0/) |
| [buildkit-v0.21.0-rc2](./buildkit/v0.21.0-rc2/) |
| [buildkit-v0.21.0-rc1](./buildkit/v0.21.0-rc1/) |
| [buildkit-v0.20.2](./buildkit/v0.20.2/) |
| [buildkit-v0.12.5-debug](./buildkit/v0.12.5-debug/) |
| [buildkit-v0.12.5](./buildkit/v0.12.5/) |
| [buildkit-v0.12.4-debug](./buildkit/v0.12.4-debug/) |
| [buildkit-v0.12.4](./buildkit/v0.12.4/) |
| [buildkit-v0.12.0](./buildkit/v0.12.0/) |
| [buildkit-v0.11.0](./buildkit/v0.11.0/) |
| [buildkit-v0.11.0-rc2](./buildkit/v0.11.0-rc2/) |
| [buildkit-v0.11.0-rc1](./buildkit/v0.11.0-rc1/) |
| [buildkit-v0.10.6](./buildkit/v0.10.6/) |
| [buildkit-v0.10.5](./buildkit/v0.10.5/) |
| [buildkit-v0.10.3](./buildkit/v0.10.3/) |
| [buildkit-v0.10.0](./buildkit/v0.10.0/) |

### containerd

| image |
|-----|
| [containerd-v2.2.3](./containerd/v2.2.3/) |
| [containerd-v2.2.1](./containerd/v2.2.1/) |
| [containerd-v2.2.0](./containerd/v2.2.0/) |
| [containerd-v2.1.5](./containerd/v2.1.5/) |
| [containerd-v2.1.4](./containerd/v2.1.4/) |
| [containerd-v2.1.3](./containerd/v2.1.3/) |
| [containerd-v2.1.2](./containerd/v2.1.2/) |
| [containerd-v2.1.1](./containerd/v2.1.1/) |
| [containerd-v2.1.1-debug](./containerd/v2.1.1-debug/) |
| [containerd-v2.0.4](./containerd/v2.0.4/) |
| [containerd-v2.0.3](./containerd/v2.0.3/) |
| [containerd-v2.1.0](./containerd/v2.1.0/) |
| [containerd-v2.1.0-debug](./containerd/v2.1.0-debug/) |
| [containerd-v2.1.0-rc.1](./containerd/v2.1.0-rc.1/) |
| [containerd-v2.1.0-rc.0](./containerd/v2.1.0-rc.0/) |
| [containerd-v2.1.0-beta.1](./containerd/v2.1.0-beta.1/) |
| [containerd-v2.1.0-beta.0](./containerd/v2.1.0-beta.0/) |
| [containerd-v2.0.5](./containerd/v2.0.5/) |
| [containerd-v2.0.4-fuse-overlayfs](./containerd/v2.0.4-fuse-overlayfs/) |
| [containerd-v2.0.2](./containerd/v2.0.2/) |
| [containerd-v1.7.18](./containerd/v1.7.18/) |
| [containerd-v1.7.16](./containerd/v1.7.16/) |
| [containerd-v1.7.15](./containerd/v1.7.15/) |
| [containerd-v1.7.13](./containerd/v1.7.13/) |
| [containerd-v1.7.8](./containerd/v1.7.8/) |
| [containerd-v1.7.6](./containerd/v1.7.6/) |
| [containerd-v1.7.3](./containerd/v1.7.3/) |
| [containerd-v1.7.1](./containerd/v1.7.1/) |
| [containerd-v1.7.0](./containerd/v1.7.0/) |
| [containerd-v1.6.21](./containerd/v1.6.21/) |
| [containerd-v1.6.19](./containerd/v1.6.19/) |
| [containerd-v1.6.16](./containerd/v1.6.16/) |
| [containerd-v1.6.12](./containerd/v1.6.12/) |
| [containerd-v1.6.9](./containerd/v1.6.9/) |
| [containerd-v1.6.8](./containerd/v1.6.8/) |
| [containerd-v1.6.7](./containerd/v1.6.7/) |
| [containerd-v1.6.6](./containerd/v1.6.6/) |
| [containerd-v1.6.4](./containerd/v1.6.4/) |
| [containerd-v1.6.2](./containerd/v1.6.2/) |
| [containerd-v1.6.0](./containerd/v1.6.0/) |
| [containerd-v1.5.9](./containerd/v1.5.9/) |
| [containerd-v1.5.8](./containerd/v1.5.8/) |
| [containerd-v1.5.7](./containerd/v1.5.7/) |
| [containerd-v1.5.6](./containerd/v1.5.6/) |
| [containerd-v1.5.4](./containerd/v1.5.4/) |
| [containerd-v1.5.2](./containerd/v1.5.2/) |
| [containerd-v1.5.1](./containerd/v1.5.1/) |
| [containerd-v1.5.0-rc.1](./containerd/v1.5.0-rc.1/) |
| [containerd-v1.5.0-beta.2](./containerd/v1.5.0-beta.2/) |
| [containerd-v1.4.3](./containerd/v1.4.3/) |
| [containerd-v1.4.0](./containerd/v1.4.0/) |
| [containerd-v1.3.8](./containerd/v1.3.8/) |
| [containerd-v1.3.3](./containerd/v1.3.3/) |
| [containerd-v1.3.0](./containerd/v1.3.0/) |
| [containerd-v1.2.0](./containerd/v1.2.0/) |
| [containerd-v1.1.0](./containerd/v1.1.0/) |
| [containerd-v1.0.1](./containerd/v1.0.1/) |
| [containerd-v1.0.0](./containerd/v1.0.0/) |
| [containerd-v0.2.9](./containerd/v0.2.9/) |
| [containerd-v0.2.4](./containerd/v0.2.4/) |

### nerdctl

| image |
|-----|
| [nerdctl-v2.1.2-apparmor](./nerdctl/v2.1.2-apparmor/) |
| [nerdctl-v2.1.2](./nerdctl/v2.1.2/) |
| [nerdctl-v2.1.1](./nerdctl/v2.1.1/) |
| [nerdctl-v2.0.5](./nerdctl/v2.0.5/) |
| [nerdctl-v2.0.4_runc-v1.2.5-debug](./nerdctl/v2.0.4_runc-v1.2.5-debug/) |
| [nerdctl-v2.0.4](./nerdctl/v2.0.4/) |
| [nerdctl-v2.0.3_containerd-v2.0.3](./nerdctl/v2.0.3_containerd-v2.0.3/) |
| [nerdctl-v2.0.3](./nerdctl/v2.0.3/) |
| [nerdctl-v1.7.4](./nerdctl/v1.7.4/) |
| [nerdctl-v1.7.3](./nerdctl/v1.7.3/) |
| [nerdctl-v1.7.0](./nerdctl/v1.7.0/) |
| [nerdctl-v1.6.0](./nerdctl/v1.6.0/) |
| [nerdctl-v1.5.0](./nerdctl/v1.5.0/) |
| [nerdctl-v1.4.0](./nerdctl/v1.4.0/) |
| [nerdctl-v1.3.0](./nerdctl/v1.3.0/) |
| [nerdctl-v1.2.0](./nerdctl/v1.2.0/) |
| [nerdctl-v1.1.0](./nerdctl/v1.1.0/) |
| [nerdctl-v1.0.0](./nerdctl/v1.0.0/) |
| [nerdctl-v0.23.0](./nerdctl/v0.23.0/) |
| [nerdctl-v0.22.0](./nerdctl/v0.22.0/) |
| [nerdctl-v0.21.0](./nerdctl/v0.21.0/) |
| [nerdctl-v0.20.0](./nerdctl/v0.20.0/) |
| [nerdctl-v0.19.0](./nerdctl/v0.19.0/) |
| [nerdctl-v0.18.0](./nerdctl/v0.18.0/) |
| [nerdctl-v0.17.0](./nerdctl/v0.17.0/) |
| [nerdctl-v0.16.0](./nerdctl/v0.16.0/) |
| [nerdctl-v0.15.0](./nerdctl/v0.15.0/) |
| [nerdctl-v0.14.0](./nerdctl/v0.14.0/) |
| [nerdctl-v0.13.0](./nerdctl/v0.13.0/) |
| [nerdctl-v0.12.0](./nerdctl/v0.12.0/) |
| [nerdctl-v0.11.0](./nerdctl/v0.11.0/) |
| [nerdctl-v0.10.0](./nerdctl/v0.10.0/) |
| [nerdctl-v0.9.0](./nerdctl/v0.9.0/) |
| [nerdctl-v0.7.0-beta.0](./nerdctl/v0.7.0-beta.0/) |
| [nerdctl-v0.5.0](./nerdctl/v0.5.0/) |

### docker

| image |
|-----|
| [docker-v1.0.1-lxc](./docker/v1.0.1-lxc/) |
| [docker-v1.0.1](./docker/v1.0.1/) |
| [docker-v1.0.0-lxc](./docker/v1.0.0-lxc/) |
| [docker-v1.0.0](./docker/v1.0.0/) |
| [docker-v1.12.3-rc1](./docker/v1.12.3-rc1/) |
| [docker-v1.12.6](./docker/v1.12.6/) |
| [docker-v1.12.5](./docker/v1.12.5/) |
| [docker-v1.12.4](./docker/v1.12.4/) |
| [docker-v1.12.3](./docker/v1.12.3/) |
| [docker-v1.12.2-rc3](./docker/v1.12.2-rc3/) |
| [docker-v1.12.2-rc2](./docker/v1.12.2-rc2/) |
| [docker-v1.12.2](./docker/v1.12.2/) |
| [docker-v1.12.1](./docker/v1.12.1/) |
| [docker-v17.06.0](./docker/v17.06.0/) |
| [docker-v19.03.13](./docker/v19.03.13/) |
| [docker-v19.03.13-debug](./docker/v19.03.13-debug/) |
| [docker-v20.10.17](./docker/v20.10.17/) |
| [docker-v20.10.19](./docker/v20.10.19/) |
| [docker-v20.10.24](./docker/v20.10.24/) |
| [docker-v23.0.0](./docker/v23.0.0/) |
| [docker-v23.0.0-devicemapper](./docker/v23.0.0-devicemapper/) |
| [docker-v23.0.3](./docker/v23.0.3/) |
| [docker-v23.0.6](./docker/v23.0.6/) |
| [docker-v23.0.6-aufs](./docker/v23.0.6-aufs/) |
| [docker-v24.0.5](./docker/v24.0.5/) |
| [docker-v26.1.4](./docker/v26.1.4/) |
| [docker-v27.0.3](./docker/v27.0.3/) |
| [docker-v27.1.0](./docker/v27.1.0/) |
| [docker-v27.3.1](./docker/v27.3.1/) |
| [docker-v27.5.0](./docker/v27.5.0/) |
| [docker-v27.5.1](./docker/v27.5.1/) |
| [docker-v28.0.0](./docker/v28.0.0/) |
| [docker-v28.0.0-rc.1](./docker/v28.0.0-rc.1/) |
| [docker-v28.0.1](./docker/v28.0.1/) |
| [docker-v28.0.4](./docker/v28.0.4/) |
| [docker-v28.0.4-debug](./docker/v28.0.4-debug/) |
| [docker-v28.0.4-centos-stream9](./docker/v28.0.4-centos-stream9/) |
| [docker-v28.0.4-centos-stream9-runc-v1.2.5-debug](./docker/v28.0.4-centos-stream9-runc-v1.2.5-debug/) |
| [docker-v28.1.1](./docker/v28.1.1/) |
| [docker-v28.2.0](./docker/v28.2.0/) |
| [docker-v28.2.2](./docker/v28.2.2/) |
| [docker-v28.2.2-containerd-v2.1.0](./docker/v28.2.2-containerd-v2.1.0/) |
| [docker-v28.3.2](./docker/v28.3.2/) |
| [docker-v28.3.2-cron](./docker/v28.3.2-cron/) |
| [docker-v0.9.0-lxc](./docker/v0.9.0-lxc/) |
| [docker-v0.12.0-lxc](./docker/v0.12.0-lxc/) |
| [docker-v0.12.0](./docker/v0.12.0/) |
| [docker-v20.10.12](./docker/v20.10.12/) |
| [docker-v0.7.1](./docker/v0.7.1/) |
| [docker-v0.7.2](./docker/v0.7.2/) |
| [docker-v0.9.0](./docker/v0.9.0/) |
| [docker-v0.11.1](./docker/v0.11.1/) |
| [docker-v0.11.1-lxc](./docker/v0.11.1-lxc/) |
| [docker-v29.4.1](./docker/v29.4.1/) |
| [docker-v29.4.1-debian](./docker/v29.4.1-debian/) |
| [docker-v29.5.2](./docker/v29.5.2/) |
| [docker-v29.5.2-criu](./docker/v29.5.2-criu/) |

### podman

| image |
|-----|
| [podman-v5.4.0](./podman/v5.4.0/) |
| [podman-v5.5.1](./podman/v5.5.1/) |
| [podman-v5.5.1-debug](./podman/v5.5.1-debug/) |

### docker-compose

| image |
|-----|
| [docker-compose-v2.40.2](./docker-compose/v2.40.2/) |
| [docker-compose-v2.40.1](./docker-compose/v2.40.1/) |
| [docker-compose-v2.40.0](./docker-compose/v2.40.0/) |
| [docker-compose-v2.39.4](./docker-compose/v2.39.4/) |

### kubenertes

#### v1.35.1

| image | note |
|-----|------|
| [kubernetes-v1.35.1_containerd-v2.2.1_calico_debug](./kubernetes/v1.35.1/containerd/v2.2.1/calico/debug) | debug kubelet,containerd |

### nvidia-container-toolkit

| image |
|-----|
| [nvidia-container-toolkit-v1.19.0](./nvidia-container-toolkit/v1.19.0/) |
| [nvidia-container-toolkit-v1.17.8](./nvidia-container-toolkit/v1.17.8/) |
| [nvidia-container-toolkit-v1.17.7](./nvidia-container-toolkit/v1.17.7/) |
| [nvidia-container-toolkit-v1.17.6-docker-v28.0.0-rc.1](./nvidia-container-toolkit/v1.17.6-docker-v28.0.0-rc.1/) |
| [nvidia-container-toolkit-v1.17.6-podman-v5.5.1](./nvidia-container-toolkit/v1.17.6-podman-v5.5.1/) |
| [nvidia-container-toolkit-v1.17.6-runc-v1.3.0-rc.2](./nvidia-container-toolkit/v1.17.6-runc-v1.3.0-rc.2/) |
| [nvidia-container-toolkit-v1.17.6-docker-v27.5.1](./nvidia-container-toolkit/v1.17.6-docker-v27.5.1/) |
| [nvidia-container-toolkit-v1.17.6-debug](./nvidia-container-toolkit/v1.17.6-debug/) |
| [nvidia-container-toolkit-v1.17.6](./nvidia-container-toolkit/v1.17.6/) |
| [nvidia-container-toolkit-v1.17.5](./nvidia-container-toolkit/v1.17.5/) |
| [nvidia-container-toolkit-v1.17.4](./nvidia-container-toolkit/v1.17.4/) |
| [nvidia-container-toolkit-v1.17.3](./nvidia-container-toolkit/v1.17.3/) |
| [nvidia-container-toolkit-v1.17.2](./nvidia-container-toolkit/v1.17.2/) |
| [nvidia-container-toolkit-v1.17.1](./nvidia-container-toolkit/v1.17.1/) |
| [nvidia-container-toolkit-v1.17.0](./nvidia-container-toolkit/v1.17.0/) |
| [nvidia-container-toolkit-v1.17.0-rc.2](./nvidia-container-toolkit/v1.17.0-rc.2/) |
| [nvidia-container-toolkit-v1.17.0-rc.1](./nvidia-container-toolkit/v1.17.0-rc.1/) |
| [nvidia-container-toolkit-v1.16.2](./nvidia-container-toolkit/v1.16.2/) |
| [nvidia-container-toolkit-v1.16.1](./nvidia-container-toolkit/v1.16.1/) |
| [nvidia-container-toolkit-v1.16.0](./nvidia-container-toolkit/v1.16.0/) |
| [nvidia-container-toolkit-v1.14.0](./nvidia-container-toolkit/v1.14.0/) |
| [nvidia-container-toolkit-v1.13.0](./nvidia-container-toolkit/v1.13.0/) |
| [nvidia-container-toolkit-v1.12.0](./nvidia-container-toolkit/v1.12.0/) |
| [nvidia-container-toolkit-v1.10.0](./nvidia-container-toolkit/v1.10.0/) |
| [kubernetes-v1.35.1_containerd-v2.2.1_calico](./kubernetes/v1.35.1/containerd/v2.2.1/calico/default) | calico installed |
| [kubernetes-v1.35.1_containerd-v2.2.1_init](./kubernetes/v1.35.1/containerd/v2.2.1/init) | kubeadm init, without CNI |
| [kubernetes-v1.35.1_containerd-v2.2.1_base](./kubernetes/v1.35.1/containerd/v2.2.1/base) | k8s components installed |

#### v1.35.0

| image | note |
|-----|------|
| [kubernetes-v1.35.0_containerd-v2.2.0_calico_nerdctl-v2.2.0](./kubernetes/v1.35.0/containerd/v2.2.0/calico/nerdctl-v2.2.0) | calico + nerdctl installed |
| [kubernetes-v1.35.0_containerd-v2.2.0_calico](./kubernetes/v1.35.0/containerd/v2.2.0/calico/default) | calico installed |
| [kubernetes-v1.35.0_containerd-v2.2.0_init](./kubernetes/v1.35.0/containerd/v2.2.0/init) | kubeadm init, without CNI |
| [kubernetes-v1.35.0_containerd-v2.2.0_base](./kubernetes/v1.35.0/containerd/v2.2.0/base) | k8s components installed |

#### v1.34.0

| image | note |
|-----|------|
| [kubernetes-v1.34.0_containerd-v2.1.4_calico_nerdctl-v2.1.4](./kubernetes/v1.34.0/containerd/v2.1.4/calico/nerdctl-v2.1.4) | calico + nerdctl installed |
| [kubernetes-v1.34.0_containerd-v2.1.4_calico](./kubernetes/v1.34.0/containerd/v2.1.4/calico/default) | calico installed |
| [kubernetes-v1.34.0_containerd-v2.1.4_init](./kubernetes/v1.34.0/containerd/v2.1.4/init) | kubeadm init, without CNI |
| [kubernetes-v1.34.0_containerd-v2.1.4_base](./kubernetes/v1.34.0/containerd/v2.1.4/base) | k8s components installed |

#### v1.33.3

| image | note |
|-----|------|
| [kubernetes-v1.33.3_containerd-v2.1.3_init](./kubernetes/v1.33.3/containerd/v2.1.3/init) | kubeadm init, without CNI |
| [kubernetes-v1.33.3_containerd-v2.1.3_base](./kubernetes/v1.33.3/containerd/v2.1.3/base) | k8s components installed |
| [kubernetes-v1.33.3_containerd-v2.1.2_calico](./kubernetes/v1.33.3/containerd/v2.1.2/calico/default) | kubeadm init, with calico |
| [kubernetes-v1.33.3_containerd-v2.1.2_init](./kubernetes/v1.33.3/containerd/v2.1.2/init) | kubeadm init, without CNI |
| [kubernetes-v1.33.3_containerd-v2.1.2_base](./kubernetes/v1.33.3/containerd/v2.1.2/base) | k8s components installed |
| [kubernetes-v1.33.3_containerd-v2.1.1_calico](./kubernetes/v1.33.3/containerd/v2.1.1/calico/default) | kubeadm init, with calico |
| [kubernetes-v1.33.3_containerd-v2.1.1_init](./kubernetes/v1.33.3/containerd/v2.1.1/init) | kubeadm init, without CNI |
| [kubernetes-v1.33.3_containerd-v2.1.1_base](./kubernetes/v1.33.3/containerd/v2.1.1/base) | k8s components installed |

#### v1.33.4

| image | note |
|-----|------|
| [kubernetes-v1.33.4_containerd-v2.1.4_calico](./kubernetes/v1.33.4/containerd/v2.1.4/calico/default) | calico installed |
| [kubernetes-v1.33.4_containerd-v2.1.4_init](./kubernetes/v1.33.4/containerd/v2.1.4/init) | kubeadm init, without CNI |
| [kubernetes-v1.33.4_containerd-v2.1.4_base](./kubernetes/v1.33.4/containerd/v2.1.4/base) | k8s components installed |

#### v1.33.7

| image | note |
|-----|------|
| [kubernetes-v1.33.7_containerd-v2.1.5_calico](./kubernetes/v1.33.7/containerd/v2.1.5/calico/default) | calico installed |
| [kubernetes-v1.33.7_containerd-v2.1.5_init](./kubernetes/v1.33.7/containerd/v2.1.5/init) | kubeadm init, without CNI |
| [kubernetes-v1.33.7_containerd-v2.1.5_base](./kubernetes/v1.33.7/containerd/v2.1.5/base) | k8s components installed |

#### v1.33.8

| image | note |
|-----|------|
| [kubernetes-v1.33.8_containerd-v2.2.1_calico_debug](./kubernetes/v1.33.8/containerd/v2.2.1/calico/debug) | debug kubelet,containerd |
| [kubernetes-v1.33.8_containerd-v2.2.1_calico](./kubernetes/v1.33.8/containerd/v2.2.1/calico/default) | calico installed |
| [kubernetes-v1.33.8_containerd-v2.2.1_init](./kubernetes/v1.33.8/containerd/v2.2.1/init) | kubeadm init, without CNI |
| [kubernetes-v1.33.8_containerd-v2.2.1_base](./kubernetes/v1.33.8/containerd/v2.2.1/base) | k8s components installed |

#### v1.32.4

| image | note |
|-----|------|
| [kubernetes-v1.32.4_containerd-v2.0.4_calico_nerdctl-v2.0.4](./kubernetes/v1.32.4/containerd/v2.0.4/calico/nerdctl-v2.0.4) | calico + nerdctl installed |
| [kubernetes-v1.32.4_containerd-v2.0.4_calico](./kubernetes/v1.32.4/containerd/v2.0.4/calico/default) | calico installed |
| [kubernetes-v1.32.4_containerd-v2.0.4_init](./kubernetes/v1.32.4/containerd/v2.0.4/init) | kubeadm init, without CNI |
| [kubernetes-v1.32.4_containerd-v2.0.4_base](./kubernetes/v1.32.4/containerd/v2.0.4/base) | k8s components installed |

#### v1.32.3

| image | note |
|-----|------|
| [kubernetes-v1.32.3_containerd-v2.0.3_calico](./kubernetes/v1.32.3/containerd/v2.0.3/calico/default) | calico installed |
| [kubernetes-v1.32.3_containerd-v2.0.3_init](./kubernetes/v1.32.3/containerd/v2.0.3/init) | kubeadm init, without CNI |
| [kubernetes-v1.32.3_containerd-v2.0.3_base](./kubernetes/v1.32.3/containerd/v2.0.3/base) | k8s components installed |

#### v1.32.2

| image | note |
|-----|------|
| [kubernetes-v1.32.2_containerd-v2.0.4_init](./kubernetes/v1.32.2/containerd/v2.0.4/init) | kubeadm init, without CNI |
| [kubernetes-v1.32.2_containerd-v2.0.4_base](./kubernetes/v1.32.2/containerd/v2.0.4/base) | k8s components installed |
| [kubernetes-v1.32.2_containerd-v2.0.3_calico_nerdctl-v2.0.3](./kubernetes/v1.32.2/containerd/v2.0.3/calico/nerdctl-v2.0.3) | calico + nerdctl installed |
| [kubernetes-v1.32.2_containerd-v2.0.3_calico_debug](./kubernetes/v1.32.2/containerd/v2.0.3/calico/debug) | debug kubelet,containerd |
| [kubernetes-v1.32.2_containerd-v2.0.3_calico](./kubernetes/v1.32.2/containerd/v2.0.3/calico/default) | calico installed |
| [kubernetes-v1.32.2_containerd-v2.0.3_init](./kubernetes/v1.32.2/containerd/v2.0.3/init) | kubeadm init, without CNI |
| [kubernetes-v1.32.2_containerd-v2.0.3_base](./kubernetes/v1.32.2/containerd/v2.0.3/base) | k8s components installed |

#### v1.18.2

| image | note |
|-----|------|
| [kubernetes-v1.18.2_containerd-v1.3.3_init](./kubernetes/v1.18.2/containerd/v1.3.3/init/) | kubeadm init, requires cgroup v1 |
| [kubernetes-v1.18.2_containerd-v1.3.3_base](./kubernetes/v1.18.2/containerd/v1.3.3/base/) | k8s v1.18.2 components installed |
