# nvidia-container-toolkit v1.17.6 with runc v1.3.0-rc.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-runc-v1.3.0-rc.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-runc-v1.3.0-rc.2:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.17.6_runc-v1.3.0-rc.2_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-runc-v1.3.0-rc.2:ctr_v0.1.0 | replace runc with v1.3.0-rc.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.17.6_runc-v1.3.0-rc.2_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nvidia-container-toolkit/v1.17.6-runc-v1.3.0-rc.2
$ ssh dqd-nvidia-container-toolkit-v1.17.6-runc-v1.3.0-rc.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.17.6-runc-v1.3.0-rc.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# rm -f /tmp/nct-docker-legacy.cid
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# docker run -tid --cidfile /tmp/nct-docker-legacy.cid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/$(cat /tmp/nct-docker-legacy.cid)/config.json | jq .hooks
<!-- VERIFY -->
```

### Generate and use CDI devices

```shell
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# nvidia-ctk cdi list
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# rm -f /tmp/nct-docker-cdi.cid
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# docker run -tid --cidfile /tmp/nct-docker-cdi.cid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/$(cat /tmp/nct-docker-cdi.cid)/config.json | jq .hooks
<!-- VERIFY -->
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# lsmod | grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# runc --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# docker --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-runc-1-3-0-rc-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.17.6-runc-v1.3.0-rc.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-runc-v1.3.0-rc.2:ctr_v0.1.0
```
