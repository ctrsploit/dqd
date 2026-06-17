# nvidia-container-toolkit v1.13.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.13.0:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.13.0:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.13.0_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.13.0:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.13.0_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.13.0
$ ssh dqd-nvidia-container-toolkit-v1.13.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.13.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

https://web.archive.org/web/20230627162323/https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-13-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<cid>/config.json | jq .hooks
<!-- VERIFY -->
```

### CDI mode

```shell
root@nvidia-container-toolkit-1-13-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# sed -i s/auto/cdi/g /etc/nvidia-container-runtime/config.toml
root@nvidia-container-toolkit-1-13-0:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all ubuntu
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<cid>/config.json | jq .hooks
<!-- VERIFY -->
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-13-0:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# lsmod |grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-13-0:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# docker info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-13-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.13.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.13.0:ctr_v0.9.0
```
