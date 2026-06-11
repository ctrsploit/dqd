# nvidia-container-toolkit v1.16.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.1:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.1:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.16.1_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.1:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.16.1_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.16.1
$ ssh dqd-nvidia-container-toolkit-v1.16.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.16.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-16-1:~# docker run -tid --runtime=nvidia --gpus=all busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
b05093807bb0: Pull complete
Digest: sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
Status: Downloaded newer image for busybox:latest
5314183a3a4242486836fb427999a91f13774d36b5719762101dcebd4bb6935c
root@nvidia-container-toolkit-1-16-1:~# cat /run/containerd/io.containerd.runtime.v1.linux/moby/5314183a3a4242486836fb427999a91f13774d36b5719762101dcebd4bb6935c/config.json | jq .hooks
{
  "prestart": [
    {
      "path": "/usr/bin/nvidia-container-runtime-hook",
      "args": ["nvidia-container-runtime-hook", "prestart"]
    }
  ],
  "createContainer": [
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": ["nvidia-ctk", "hook", "enable-cuda-compat", "--host-driver-version=575.57.08"]
    },
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": ["nvidia-ctk", "hook", "update-ldcache"]
    }
  ]
}
```

### CDI mode

```shell
root@nvidia-container-toolkit-1-16-1:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
time="2026-06-11T07:53:14Z" level=info msg="Generated CDI spec with version 0.8.0"
root@nvidia-container-toolkit-1-16-1:~# nvidia-ctk cdi list
time="2026-06-11T07:53:14Z" level=info msg="Found 9 CDI devices"
nvidia.com/gpu=0
nvidia.com/gpu=1
nvidia.com/gpu=2
nvidia.com/gpu=3
nvidia.com/gpu=GPU-0-FAKE-UUID
nvidia.com/gpu=GPU-1-FAKE-UUID
nvidia.com/gpu=GPU-2-FAKE-UUID
nvidia.com/gpu=GPU-3-FAKE-UUID
nvidia.com/gpu=all
root@nvidia-container-toolkit-1-16-1:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
9993826006a41cff5935eb6ef224632c5dd01a9b920e40a1ade5fa5197eebd69
root@nvidia-container-toolkit-1-16-1:~# cat /run/containerd/io.containerd.runtime.v1.linux/moby/9993826006a41cff5935eb6ef224632c5dd01a9b920e40a1ade5fa5197eebd69/config.json | jq .hooks
{
  "createContainer": [
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": ["nvidia-cdi-hook", "create-symlinks", "--link", "libcuda.so.1::/usr/lib/x86_64-linux-gnu/libcuda.so", "--link", "libnvidia-opticalflow.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so", "--link", "libGLX_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLX_indirect.so.0"]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": ["nvidia-cdi-hook", "enable-cuda-compat", "--host-driver-version=575.57.08"]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": ["nvidia-cdi-hook", "update-ldcache", "--folder", "/usr/lib/x86_64-linux-gnu"]
    }
  ]
}
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-16-1:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-16-1:~# lsmod |grep fake
fake_nvidia_driver     12288  0
root@nvidia-container-toolkit-1-16-1:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
lrwxrwxrwx 1 root root  43 Jun 11 07:41 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  51 Jun 11 07:41 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root 22K Jun 11 07:41 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-16-1:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; preset: enabled)
     Active: inactive (dead) since Thu 2026-06-11 07:52:54 UTC; 20s ago
    Process: 644 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 644 (code=exited, status=0/SUCCESS)
        CPU: 9ms

Jun 11 07:52:54 nvidia-container-toolkit-1-16-1 systemd[1]: Starting fake-nvidia-device.service
Jun 11 07:52:54 nvidia-container-toolkit-1-16-1 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jun 11 07:52:54 nvidia-container-toolkit-1-16-1 systemd[1]: Finished fake-nvidia-device.service
```

### versions

```shell
root@nvidia-container-toolkit-1-16-1:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.16.1
commit: a470818ba7d9166be282cd0039dd2fc9b0a34d73
root@nvidia-container-toolkit-1-16-1:~# docker --version
Docker version 27.1.0, build 6312585
root@nvidia-container-toolkit-1-16-1:~# containerd --version
containerd containerd.io 1.7.20 8fc6bcff51318944179630522a095cc9dbf9f353
root@nvidia-container-toolkit-1-16-1:~# cat /etc/os-release
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
root@nvidia-container-toolkit-1-16-1:~# uname -a
Linux nvidia-container-toolkit-1-16-1 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.16.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.16.1:ctr_v0.9.0
```
