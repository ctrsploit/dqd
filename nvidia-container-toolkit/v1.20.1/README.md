# nvidia-container-toolkit v1.20.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:v0.1.0 | nvidia-container-toolkit 1.20.1 |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:ctr_v0.1.0 | install real nvidia driver without kernel module; install i386 libs; fake-nvidia v0.8.3; nvidia-container-toolkit 1.20.1 |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.20.1
$ ssh dqd-nvidia-container-toolkit-v1.20.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.20.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-20-1:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# docker ps -lq
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/$(docker ps -lq)/config.json | jq .hooks
<!-- VERIFY -->
```

### Generate and use CDI devices

```shell
root@nvidia-container-toolkit-1-20-1:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# nvidia-ctk cdi list
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/$(docker ps -lq)/config.json | jq .hooks
<!-- VERIFY -->
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-20-1:~# nvidia-container-cli info
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# lsmod | grep fake
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-20-1:~# nvidia-container-toolkit --version
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# docker --version
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# containerd --version
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# cat /etc/os-release
<!-- VERIFY -->
```

```shell
root@nvidia-container-toolkit-1-20-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.20.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:ctr_v0.1.0
```
