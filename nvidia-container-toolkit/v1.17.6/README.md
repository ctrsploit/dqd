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

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-17-6:~# docker run -tid --runtime=nvidia --gpus=all busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
b05093807bb0: Pulling fs layer
b05093807bb0: Verifying Checksum
b05093807bb0: Download complete
b05093807bb0: Pull complete
Digest: sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
Status: Downloaded newer image for busybox:latest
87b90558ad4a7e6fedfb8c66a1b83bf6669271fceea41cb2c543e32889c2792b
root@nvidia-container-toolkit-1-17-6:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/87b90558ad4a7e6fedfb8c66a1b83bf6669271fceea41cb2c543e32889c2792b/config.json | jq .hooks
{
  "prestart": [
    {
      "path": "/usr/bin/nvidia-container-runtime-hook",
      "args": [
        "nvidia-container-runtime-hook",
        "prestart"
      ],
      "env": [
        "LANG=C.UTF-8",
        "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin",
        "NOTIFY_SOCKET=/run/systemd/notify",
        "USER=root",
        "INVOCATION_ID=224b7e10bbe343e98ccad882ea838b4d",
        "JOURNAL_STREAM=8:6275",
        "SYSTEMD_EXEC_PID=427",
        "MEMORY_PRESSURE_WATCH=/sys/fs/cgroup/system.slice/docker.service/memory.pressure",
        "MEMORY_PRESSURE_WRITE=c29tZSAyMDAwMDAgMjAwMDAwMAA=",
        "OTEL_SERVICE_NAME=dockerd",
        "OTEL_EXPORTER_OTLP_TRACES_PROTOCOL=http/protobuf",
        "OTEL_EXPORTER_OTLP_METRICS_PROTOCOL=http/protobuf",
        "TMPDIR=/var/lib/docker/tmp"
      ]
    }
  ],
  "createContainer": [
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "enable-cuda-compat",
        "--host-driver-version=575.57.08"
      ]
    },
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "update-ldcache"
      ]
    }
  ]
}
```

### CDI mode

```shell
root@nvidia-container-toolkit-1-17-6:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
time="2026-06-09T08:31:15Z" level=info msg="Auto-detected mode as 'nvml'"
...
time="2026-06-09T08:31:15Z" level=info msg="Generated CDI spec with version 0.8.0"
root@nvidia-container-toolkit-1-17-6:~# nvidia-ctk cdi list
time="2026-06-09T08:31:15Z" level=info msg="Found 9 CDI devices"
nvidia.com/gpu=0
nvidia.com/gpu=1
nvidia.com/gpu=2
nvidia.com/gpu=3
nvidia.com/gpu=GPU-0-FAKE-UUID
nvidia.com/gpu=GPU-1-FAKE-UUID
nvidia.com/gpu=GPU-2-FAKE-UUID
nvidia.com/gpu=GPU-3-FAKE-UUID
nvidia.com/gpu=all
root@nvidia-container-toolkit-1-17-6:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
636dc230dfd01f576f5e5c0829af468290fd42b7449ce12b42684b1ae9578dfd
root@nvidia-container-toolkit-1-17-6:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/636dc230dfd01f576f5e5c0829af468290fd42b7449ce12b42684b1ae9578dfd/config.json | jq .hooks
{
  "createContainer": [
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "create-symlinks",
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
        "create-symlinks",
        "--link",
        "libcuda.so.1::/usr/lib/x86_64-linux-gnu/libcuda.so",
        "--link",
        "libnvidia-opticalflow.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so",
        "--link",
        "libGLX_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLX_indirect.so.0"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "enable-cuda-compat",
        "--host-driver-version=575.57.08"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "update-ldcache",
        "--folder",
        "/usr/lib/x86_64-linux-gnu",
        "--folder",
        "/usr/lib/x86_64-linux-gnu/vdpau"
      ]
    }
  ]
}
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-17-6:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-17-6:~# lsmod |grep fake
fake_nvidia_driver     12288  0
root@nvidia-container-toolkit-1-17-6:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
lrwxrwxrwx 1 root root  43 Jun  9 08:11 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  51 Jun  9 08:11 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root 22K Jun  9 08:11 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-17-6:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; preset: enabled)
     Active: inactive (dead) since Tue 2026-06-09 08:30:53 UTC; 21s ago
    Process: 640 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 640 (code=exited, status=0/SUCCESS)
        CPU: 9ms

Jun 09 08:30:53 nvidia-container-toolkit-1-17-6 systemd[1]: Starting fake-nvidia-device.service - Create device nodes for fake nvidia driver...
Jun 09 08:30:53 nvidia-container-toolkit-1-17-6 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jun 09 08:30:53 nvidia-container-toolkit-1-17-6 systemd[1]: Finished fake-nvidia-device.service - Create device nodes for fake nvidia driver.
```

### versions

```shell
root@nvidia-container-toolkit-1-17-6:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.17.6
commit: e627eb2e21e167988e04c0579a1c941c1e263ff6
root@nvidia-container-toolkit-1-17-6:~# docker --version
Docker version 28.1.1, build 4eba377
root@nvidia-container-toolkit-1-17-6:~# containerd --version
containerd containerd.io 1.7.27 05044ec0a9a75232cad458027ca83437aae3f4da
root@nvidia-container-toolkit-1-17-6:~# cat /etc/os-release
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
root@nvidia-container-toolkit-1-17-6:~# uname -a
Linux nvidia-container-toolkit-1-17-6 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.17.6
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6:ctr_v0.9.0
```
