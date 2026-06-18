# nvidia-container-toolkit v1.16.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.0:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.0:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.16.0_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.0:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.16.0_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.16.0
$ ssh dqd-nvidia-container-toolkit-v1.16.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.16.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-16-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
b05093807bb0: Pulling fs layer
b05093807bb0: Download complete
b05093807bb0: Pull complete
Digest: sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
Status: Downloaded newer image for busybox:latest
5a1f6c07c60a0b6232c708803229a35809005d48f7bd0eaee9301c33b7091366
root@nvidia-container-toolkit-1-16-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/5a1f6c07c60a0b6232c708803229a35809005d48f7bd0eaee9301c33b7091366/config.json | jq .hooks
{
  "prestart": [
    {
      "path": "/usr/bin/nvidia-container-runtime-hook",
      "args": [
        "nvidia-container-runtime-hook",
        "prestart"
      ]
    },
    {
      "path": "/proc/427/exe",
      "args": [
        "libnetwork-setkey",
        "-exec-root=/var/run/docker",
        "5a1f6c07c60a0b6232c708803229a35809005d48f7bd0eaee9301c33b7091366",
        "c5df5bff4ab3"
      ]
    }
  ]
}
```

### CDI mode

```shell
root@nvidia-container-toolkit-1-16-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
time="2026-06-18T03:28:18Z" level=info msg="Generated CDI spec with version 0.8.0"
root@nvidia-container-toolkit-1-16-0:~# nvidia-ctk cdi list
time="2026-06-18T03:28:18Z" level=info msg="Found 9 CDI devices"
nvidia.com/gpu=0
nvidia.com/gpu=1
nvidia.com/gpu=2
nvidia.com/gpu=3
nvidia.com/gpu=GPU-0-FAKE-UUID
nvidia.com/gpu=GPU-1-FAKE-UUID
nvidia.com/gpu=GPU-2-FAKE-UUID
nvidia.com/gpu=GPU-3-FAKE-UUID
nvidia.com/gpu=all
root@nvidia-container-toolkit-1-16-0:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
94ea62f6caeb7d1208b6d15c110e89f1f7f348c943bae0974ada0ed85bb1a743
root@nvidia-container-toolkit-1-16-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/94ea62f6caeb7d1208b6d15c110e89f1f7f348c943bae0974ada0ed85bb1a743/config.json | jq .hooks
{
  "prestart": [
    {
      "path": "/proc/427/exe",
      "args": [
        "libnetwork-setkey",
        "-exec-root=/var/run/docker",
        "94ea62f6caeb7d1208b6d15c110e89f1f7f348c943bae0974ada0ed85bb1a743",
        "c5df5bff4ab3"
      ]
    }
  ],
  "createContainer": [
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "create-symlinks",
        "--link",
        "libnvidia-allocator.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.1",
        "--link",
        "../libnvidia-allocator.so.1::/usr/lib/x86_64-linux-gnu/gbm/nvidia-drm_gbm.so",
        "--link",
        "libglxserver_nvidia.so.575.57.08::/usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "update-ldcache",
        "--folder",
        "/usr/lib/x86_64-linux-gnu"
      ]
    }
  ]
}
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-16-0:~# nvidia-container-cli info
NVRM version:   575.57.08
CUDA version:   12.2

Device Index:   0
Device Minor:   0
Model:          NVIDIA Tesla T4
Brand:          Tesla
GPU UUID:       GPU-0-FAKE-UUID
Bus Location:   00000000:00:00.0
Architecture:   7.5

Device Index:   1
Device Minor:   1
Model:          NVIDIA Tesla T4
Brand:          Tesla
GPU UUID:       GPU-1-FAKE-UUID
Bus Location:   00000000:00:00.0
Architecture:   7.5

Device Index:   2
Device Minor:   2
Model:          NVIDIA Tesla T4
Brand:          Tesla
GPU UUID:       GPU-2-FAKE-UUID
Bus Location:   00000000:00:00.0
Architecture:   7.5

Device Index:   3
Device Minor:   3
Model:          NVIDIA Tesla T4
Brand:          Tesla
GPU UUID:       GPU-3-FAKE-UUID
Bus Location:   00000000:00:00.0
Architecture:   7.5
root@nvidia-container-toolkit-1-16-0:~# lsmod |grep fake
fake_nvidia_driver     12288  0
root@nvidia-container-toolkit-1-16-0:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
lrwxrwxrwx 1 root root  43 Jun 18 01:56 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  51 Jun 18 01:56 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root  22K Jun 18 01:56 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-16-0:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; preset: enabled)
     Active: inactive (dead) since Thu 2026-06-18 02:42:00 UTC; 16min ago
    Process: 615 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 615 (code=exited, status=0/SUCCESS)
        CPU: 9ms

Jun 18 02:42:00 nvidia-container-toolkit-1-16-0 systemd[1]: Starting fake-nvidia-device.service - Create device nodes for fake nvidia driver...
Jun 18 02:42:00 nvidia-container-toolkit-1-16-0 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jun 18 02:42:00 nvidia-container-toolkit-1-16-0 systemd[1]: Finished fake-nvidia-device.service - Create device nodes for fake nvidia driver.
```

### versions

```shell
root@nvidia-container-toolkit-1-16-0:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.16.0
commit: c5c124b88298f520a94e4d6046ab02f643d65436
root@nvidia-container-toolkit-1-16-0:~# docker --version
Docker version 27.0.3, build 7d4bcd8
root@nvidia-container-toolkit-1-16-0:~# containerd --version
containerd containerd.io 1.7.18 ae71819c4f5e67bb4d5ae76a6b735f29cc25774e
root@nvidia-container-toolkit-1-16-0:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@nvidia-container-toolkit-1-16-0:~# uname -a
Linux nvidia-container-toolkit-1-16-0 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.16.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.0:ctr_v0.9.0
```
