# nvidia-container-toolkit v1.17.6 with podman v5.5.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-podman-v5.5.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-podman-v5.5.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.17.6_podman-v5.5.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-podman-v5.5.1:ctr_v0.1.0 | install real nvidia driver without kernel module; bump fake-nvidia to v0.7.3-rc.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.17.6_podman-v5.5.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nvidia-container-toolkit/v1.17.6-podman-v5.5.1
$ ssh dqd-nvidia-container-toolkit-v1.17.6-podman-v5.5.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.17.6-podman-v5.5.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Generate and use CDI devices

```shell
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# nvidia-ctk cdi list
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# rm -f /tmp/nct-podman.cid
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# podman run -tid --cidfile /tmp/nct-podman.cid --device nvidia.com/gpu=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# cat /run/crun/$(cat /tmp/nct-podman.cid)/config.json | jq .hooks
<!-- VERIFY -->
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# lsmod | grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# ls -lah /usr/lib64/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# crun --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# podman info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.17.6-podman-v5.5.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-podman-v5.5.1:ctr_v0.1.0
```
