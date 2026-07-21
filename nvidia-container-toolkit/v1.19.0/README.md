# nvidia-container-toolkit v1.19.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.19.0:latest | points to `v0.9.1` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.19.0:v0.9.1 | bump fake-nvidia to v0.8.2; nvidia-container-toolkit 1.19.0 |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.19.0:ctr_v0.9.1 | install real nvidia driver without kernel module; install i386 libs; fake-nvidia v0.8.2; nvidia-container-toolkit 1.19.0 |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.19.0
$ ssh dqd-nvidia-container-toolkit-v1.19.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.19.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-19-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<container-id>/config.json | jq .hooks
<!-- VERIFY -->
```

### Generate and use CDI devices

```shell
root@nvidia-container-toolkit-1-19-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# nvidia-ctk cdi list
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<container-id>/config.json | jq .hooks
<!-- VERIFY -->
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-19-0:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# lsmod | grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-19-0:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# docker --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-19-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.19.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.19.0:ctr_v0.9.1
```
