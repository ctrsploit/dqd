# nvidia-container-toolkit v1.17.6 debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-debug:latest | points to `v0.9.1` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-debug:v0.9.1 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.17.6-debug_v0.9.1 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-debug:ctr_v0.9.1 | support nvidia-container-runtime debugging |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.17.6-debug_v0.9.1 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.17.6-debug
$ ssh dqd-nvidia-container-toolkit-v1.17.6-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.17.6-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug with dlv

| Component | Host port |
| --------- | --------- |
| runc | 11765 |
| attach | 11766 |
| nvidia-container-runtime | 11767 |

```shell
root@nvidia-container-toolkit-1-17-6-debug:~# ln -sf /usr/local/bin/debug.sh /usr/bin/runc
root@nvidia-container-toolkit-1-17-6-debug:~# runc --version
```

```shell
root@nvidia-container-toolkit-1-17-6-debug:~# ln -sf /usr/local/bin/debug.sh /usr/bin/nvidia-container-runtime
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-17-6-debug:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# docker ps --latest --quiet --no-trunc | xargs -I{} sh -c 'cat /run/containerd/io.containerd.runtime.v2.task/moby/{}/config.json | jq .hooks'
<!-- VERIFY -->
```

### Generate and use CDI devices

```shell
root@nvidia-container-toolkit-1-17-6-debug:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# nvidia-ctk cdi list
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# docker ps --latest --quiet --no-trunc | xargs -I{} sh -c 'cat /run/containerd/io.containerd.runtime.v2.task/moby/{}/config.json | jq .hooks'
<!-- VERIFY -->
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-17-6-debug:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# lsmod | grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-17-6-debug:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# docker --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6-debug:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.17.6-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-debug:ctr_v0.9.1
```
