# nvidia-container-toolkit v1.16.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.2:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.2:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.16.2_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.2:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.16.2_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.16.2
$ ssh dqd-nvidia-container-toolkit-v1.16.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.16.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-16-2:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/06b4ed347e997062c460bd41160dccbea8bbb996ee3bb7e4c4d367e33bd3f2f7/config.json | jq .hooks
<!-- VERIFY -->
```

### CDI mode

```shell
root@nvidia-container-toolkit-1-16-2:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# nvidia-ctk cdi list
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/f7a878d988dd4afbbff5516c1043cc7311c858504d8baff7ffc719b73cd9612d/config.json | jq .hooks
<!-- VERIFY -->
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-16-2:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# lsmod |grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-16-2:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# docker --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-16-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.16.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.2:ctr_v0.9.0
```
