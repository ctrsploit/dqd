# nvidia-container-toolkit v1.17.6

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.17.6_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.17.6_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.17.6
$ ssh dqd-nvidia-container-toolkit-v1.17.6
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.17.6
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nvidia runtime

```shell
root@nvidia-container-toolkit-1-17-6:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/06b4ed347e997062c460bd41160dccbea8bbb996ee3bb7e4c4d367e33bd3f2f7/config.json | jq .hooks
<!-- VERIFY -->
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-17-6:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6:~# lsmod |grep fake
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-17-6:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6:~# docker --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-17-6:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.17.6
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6:ctr_v0.9.0
```
