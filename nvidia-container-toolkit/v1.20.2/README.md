# nvidia-container-toolkit v1.20.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.2:v0.1.0 | fake-nvidia v0.9.0-beta.1 (module registers as `nvidia`, CDI spec auto-generated at boot); nvidia-container-toolkit 1.20.2 |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.2:ctr_v0.1.0 | install real nvidia driver without kernel module; install i386 libs; fake-nvidia v0.9.0-beta.1; nvidia-container-toolkit 1.20.2; docker 29.10.0 |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.20.2
$ ssh dqd-nvidia-container-toolkit-v1.20.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.20.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-20-2:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/$(docker ps -lq)/config.json | jq .hooks
<!-- VERIFY -->
```

### Generate and use CDI devices

At boot `nvidia-cdi-refresh.service` already generates `/var/run/cdi/nvidia.yaml`, so `docker run --device nvidia.com/gpu=all` works out of the box. The manual `nvidia-ctk cdi generate` below writes a second spec to `/etc/cdi/nvidia.yaml` and shows what generation walks through; `nvidia-ctk cdi list` merges both files.

```shell
root@nvidia-container-toolkit-1-20-2:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# nvidia-ctk cdi list
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/$(docker ps -lq)/config.json | jq .hooks
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-2:~# docker run -tid --runtime=nvidia --device nvidia.com/gpu=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# docker exec $(docker ps -lq) ls -l /dev/nvidia*
<!-- VERIFY -->
```

### Inspect the CDI auto-refresh mechanism

Since fake-nvidia v0.9.0-beta.1 the kernel module registers under the name `nvidia` (was `fake_nvidia_driver` in v0.1.0), so both identity checks of the auto-refresh mechanism match: the udev rule below fires on the module-add event at boot, and the `ExecCondition` grep finds `nvidia.ko` in `modules.dep`. `nvidia-cdi-refresh.service` therefore generates `/var/run/cdi/nvidia.yaml` automatically at boot — no manual `nvidia-ctk cdi generate` needed.

```shell
root@nvidia-container-toolkit-1-20-2:~# systemctl status nvidia-cdi-refresh.service
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# systemctl show -p ExecCondition nvidia-cdi-refresh.service
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# grep -E "/(nvidia|nvidia-current)[.]ko" /lib/modules/$(uname -r)/modules.dep
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# modinfo nvidia
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# systemctl show -p Environment nvidia-cdi-refresh.service
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# systemctl status nvidia-cdi-refresh.path
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# grep ^ACTION /lib/udev/rules.d/99-nvidia-cdi-refresh.rules
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# ls /etc/cdi /var/run/cdi
<!-- VERIFY -->
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-20-2:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# lsmod | grep nvidia
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# nvidia-smi -L
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-20-2:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# docker --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.20.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.2:ctr_v0.1.0
```
