# nvidia-container-toolkit v1.17.7

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.7:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.7:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.17.7_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.7:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.17.7_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.17.7
$ ssh dqd-nvidia-container-toolkit-v1.17.7
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.17.7
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-17-7:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<container-id>/config.json | jq .hooks
<!-- VERIFY -->
```

### Generate and use CDI devices

```shell
root@nvidia-container-toolkit-1-17-7:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# nvidia-ctk cdi list
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<container-id>/config.json | jq .hooks
<!-- VERIFY -->
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-17-7:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# lsmod | grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-17-7:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# docker --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-7:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.17.7
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.7:ctr_v0.9.0
```
