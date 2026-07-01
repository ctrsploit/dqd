# nvidia-container-toolkit v1.17.0-rc.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.0-rc.1:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.0-rc.1:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.17.0-rc.1_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.0-rc.1:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.17.0-rc.1_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.17.0-rc.1
$ ssh dqd-nvidia-container-toolkit-v1.17.0-rc.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.17.0-rc.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-17-0-rc-1:~# docker run -tid --runtime=nvidia --gpus=all busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
b05093807bb0: Pulling fs layer
b05093807bb0: Verifying Checksum
b05093807bb0: Download complete
b05093807bb0: Pull complete
Digest: sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
Status: Downloaded newer image for busybox:latest
ad45a9c835bfe3b31be7cc6301e57d8624b8e3da00c094e5611e1e86756a2502
root@nvidia-container-toolkit-1-17-0-rc-1:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/ad45a9c835bfe3b31be7cc6301e57d8624b8e3da00c094e5611e1e86756a2502/config.json | jq .hooks
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
        "INVOCATION_ID=eaadd1c1c7594a7c999f750d2a94ae5b",
        "JOURNAL_STREAM=8:4951",
        "SYSTEMD_EXEC_PID=426",
        "MEMORY_PRESSURE_WATCH=/sys/fs/cgroup/system.slice/docker.service/memory.pressure",
        "MEMORY_PRESSURE_WRITE=c29tZSAyMDAwMDAgMjAwMDAwMAA=",
        "OTEL_SERVICE_NAME=dockerd",
        "OTEL_EXPORTER_OTLP_TRACES_PROTOCOL=http/protobuf",
        "OTEL_EXPORTER_OTLP_METRICS_PROTOCOL=http/protobuf",
        "TMPDIR=/var/lib/docker/tmp"
      ]
    },
    {
      "path": "/proc/426/exe",
      "args": [
        "libnetwork-setkey",
        "-exec-root=/var/run/docker",
        "ad45a9c835bfe3b31be7cc6301e57d8624b8e3da00c094e5611e1e86756a2502",
        "3fd22e0cc06b"
      ],
      "env": [
        "TRACEPARENT=00-7dbdf75609c50c7c9a1344b17cd46bb9-47961dbb5d04760e-01"
      ]
    }
  ]
}
```

### Generate and use CDI devices

```shell
root@nvidia-container-toolkit-1-17-0-rc-1:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
time="2026-07-01T12:10:50Z" level=info msg="Using /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Using /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Auto-detected mode as 'nvml'"
ERROR: Couldn't load symbol: /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08: undefined symbol: nvmlDeviceGetHandleByUUID
ERROR: init 243 result=6time="2026-07-01T12:10:50Z" level=warning msg="Failed to init nvsandboxutils: ERROR_LIBRARY_LOAD; ignoring"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /dev/nvidia0 as /dev/nvidia0"
time="2026-07-01T12:10:50Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x01-card; ignoring"
time="2026-07-01T12:10:50Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x01-render; ignoring"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /dev/nvidia1 as /dev/nvidia1"
time="2026-07-01T12:10:50Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x02-card; ignoring"
time="2026-07-01T12:10:50Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x02-render; ignoring"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /dev/nvidia2 as /dev/nvidia2"
time="2026-07-01T12:10:50Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x03-card; ignoring"
time="2026-07-01T12:10:50Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x03-render; ignoring"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /dev/nvidia3 as /dev/nvidia3"
time="2026-07-01T12:10:50Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x04-card; ignoring"
time="2026-07-01T12:10:50Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x04-render; ignoring"
time="2026-07-01T12:10:50Z" level=info msg="Using driver version 575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /dev/nvidia-modeset as /dev/nvidia-modeset"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate /dev/nvidia-uvm-tools: pattern /dev/nvidia-uvm-tools not found"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate /dev/nvidia-uvm: pattern /dev/nvidia-uvm not found"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /dev/nvidiactl as /dev/nvidiactl"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-egl-gbm.so.1.1.2 as /usr/lib/x86_64-linux-gnu/libnvidia-egl-gbm.so.1.1.2"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-egl-wayland.so.1.1.19 as /usr/lib/x86_64-linux-gnu/libnvidia-egl-wayland.so.1.1.19"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate libnvidia-vulkan-producer.so.575.57.08: pattern libnvidia-vulkan-producer.so.575.57.08 not found\n64-bit library libnvidia-vulkan-producer.so.575.57.08: not found"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib64/xorg/modules/drivers/nvidia_drv.so as /usr/lib64/xorg/modules/drivers/nvidia_drv.so"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so.575.57.08 as /usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/share/glvnd/egl_vendor.d/10_nvidia.json as /usr/share/glvnd/egl_vendor.d/10_nvidia.json"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/15_nvidia_gbm.json as /usr/share/egl/egl_external_platform.d/15_nvidia_gbm.json"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json as /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/share/nvidia/nvoptix.bin as /usr/share/nvidia/nvoptix.bin"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate X11/xorg.conf.d/10-nvidia.conf: pattern X11/xorg.conf.d/10-nvidia.conf not found"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate X11/xorg.conf.d/nvidia-drm-outputclass.conf: pattern X11/xorg.conf.d/nvidia-drm-outputclass.conf not found"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /etc/vulkan/icd.d/nvidia_icd.json as /etc/vulkan/icd.d/nvidia_icd.json"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate vulkan/icd.d/nvidia_layers.json: pattern vulkan/icd.d/nvidia_layers.json not found\npattern vulkan/icd.d/nvidia_layers.json not found"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /etc/vulkan/implicit_layer.d/nvidia_layers.json as /etc/vulkan/implicit_layer.d/nvidia_layers.json"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLESv2_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLESv2_nvidia.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libcuda.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libcuda.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libcudadebugger.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libcudadebugger.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvcuvid.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvcuvid.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-eglcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-eglcore.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-fbc.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-fbc.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glcore.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glsi.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glsi.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glvkspirv.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glvkspirv.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gpucomp.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gpucomp.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gtk2.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gtk2.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gtk3.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gtk3.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ngx.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ngx.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11-openssl3.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11-openssl3.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-present.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-present.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-rtcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-rtcore.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-tls.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-tls.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-vksc-core.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-vksc-core.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-wayland-client.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-wayland-client.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvoptix.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvoptix.so.575.57.08"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/vdpau/libvdpau_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/vdpau/libvdpau_nvidia.so.575.57.08"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate /nvidia-persistenced/socket: pattern /nvidia-persistenced/socket not found"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate /nvidia-fabricmanager/socket: pattern /nvidia-fabricmanager/socket not found"
time="2026-07-01T12:10:50Z" level=warning msg="Could not locate /tmp/nvidia-mps: pattern /tmp/nvidia-mps not found"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /lib/firmware/nvidia/575.57.08/gsp_ga10x.bin as /lib/firmware/nvidia/575.57.08/gsp_ga10x.bin"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /lib/firmware/nvidia/575.57.08/gsp_tu10x.bin as /lib/firmware/nvidia/575.57.08/gsp_tu10x.bin"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/bin/nvidia-smi as /usr/bin/nvidia-smi"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/bin/nvidia-debugdump as /usr/bin/nvidia-debugdump"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/bin/nvidia-persistenced as /usr/bin/nvidia-persistenced"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/bin/nvidia-cuda-mps-control as /usr/bin/nvidia-cuda-mps-control"
time="2026-07-01T12:10:50Z" level=info msg="Selecting /usr/bin/nvidia-cuda-mps-server as /usr/bin/nvidia-cuda-mps-server"
time="2026-07-01T12:10:50Z" level=info msg="Generated CDI spec with version 0.8.0"
root@nvidia-container-toolkit-1-17-0-rc-1:~# nvidia-ctk cdi list
time="2026-07-01T12:11:01Z" level=info msg="Found 9 CDI devices"
nvidia.com/gpu=0
nvidia.com/gpu=1
nvidia.com/gpu=2
nvidia.com/gpu=3
nvidia.com/gpu=GPU-0-FAKE-UUID
nvidia.com/gpu=GPU-1-FAKE-UUID
nvidia.com/gpu=GPU-2-FAKE-UUID
nvidia.com/gpu=GPU-3-FAKE-UUID
nvidia.com/gpu=all
root@nvidia-container-toolkit-1-17-0-rc-1:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
ce5e21f025df04862f21cfafeb385f81d8bb8a0daf1134ebb7d08e61aec972c5
root@nvidia-container-toolkit-1-17-0-rc-1:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/ce5e21f025df04862f21cfafeb385f81d8bb8a0daf1134ebb7d08e61aec972c5/config.json | jq .hooks
{
  "prestart": [
    {
      "path": "/proc/426/exe",
      "args": [
        "libnetwork-setkey",
        "-exec-root=/var/run/docker",
        "ce5e21f025df04862f21cfafeb385f81d8bb8a0daf1134ebb7d08e61aec972c5",
        "3fd22e0cc06b"
      ],
      "env": [
        "TRACEPARENT=00-592a4f4083a5a77626f779a5442e2b1d-77ca15f9eb28e6fa-01"
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
        "libnvidia-opticalflow.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so",
        "--link",
        "libcuda.so.1::/usr/lib/x86_64-linux-gnu/libcuda.so",
        "--link",
        "libGLX_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLX_indirect.so.0"
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

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-17-0-rc-1:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-17-0-rc-1:~# lsmod | grep fake
fake_nvidia_driver     12288  0
root@nvidia-container-toolkit-1-17-0-rc-1:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
lrwxrwxrwx 1 root root  43 Jul  1 11:55 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  51 Jul  1 11:55 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root 22K Jul  1 11:55 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-17-0-rc-1:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; preset: enabled)
     Active: inactive (dead) since Wed 2026-07-01 12:09:33 UTC; 1min 53s ago
    Process: 617 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 617 (code=exited, status=0/SUCCESS)
        CPU: 20ms

Jul 01 12:09:33 nvidia-container-toolkit-1-17-0-rc-1 systemd[1]: Starting fake-nvidia-device.service - Create device nodes for fake nvidia driver...
Jul 01 12:09:33 nvidia-container-toolkit-1-17-0-rc-1 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jul 01 12:09:33 nvidia-container-toolkit-1-17-0-rc-1 systemd[1]: Finished fake-nvidia-device.service - Create device nodes for fake nvidia driver.
```

### versions

```shell
root@nvidia-container-toolkit-1-17-0-rc-1:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.17.0-rc.1
commit: 8a6c1944a5423cf1be0c72d60a63544a78159870
root@nvidia-container-toolkit-1-17-0-rc-1:~# docker --version
Docker version 27.3.1, build ce12230
root@nvidia-container-toolkit-1-17-0-rc-1:~# containerd --version
containerd containerd.io 1.7.22 7f7fdf5fed64eb6a7caf99b3e12efcf9d60e311c
root@nvidia-container-toolkit-1-17-0-rc-1:~# cat /etc/os-release
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
root@nvidia-container-toolkit-1-17-0-rc-1:~# uname -a
Linux nvidia-container-toolkit-1-17-0-rc-1 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.17.0-rc.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.0-rc.1:ctr_v0.9.0
```
