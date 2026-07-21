# nvidia-container-toolkit v1.19.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.19.0:latest | points to `v0.9.2` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.19.0:v0.9.2 | bump fake-nvidia to v0.8.3; nvidia-container-toolkit 1.19.0 |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.19.0:ctr_v0.9.2 | install real nvidia driver without kernel module; install i386 libs; fake-nvidia v0.8.3; nvidia-container-toolkit 1.19.0 |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.19.0
$ ssh dqd-nvidia-container-toolkit-v1.19.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.19.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-19-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
cb715d99408871a093fb92e82e323bcc008578e5a8815d6ec81e1d0907c0bdc7
root@nvidia-container-toolkit-1-19-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/cb715d99408871a093fb92e82e323bcc008578e5a8815d6ec81e1d0907c0bdc7/config.json | jq .hooks
{
  "createContainer": [
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "create-symlinks",
        "--link",
        "../libnvidia-allocator.so.1::/usr/lib/x86_64-linux-gnu/gbm/nvidia-drm_gbm.so",
        "--link",
        "libglxserver_nvidia.so.575.57.08::/usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "create-symlinks",
        "--link",
        "libEGL_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0",
        "--link",
        "libGLESv1_CM_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.1",
        "--link",
        "libGLESv2_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLESv2_nvidia.so.2",
        "--link",
        "libGLX_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLX_indirect.so.0",
        "--link",
        "libGLX_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0",
        "--link",
        "libcuda.so.1::/usr/lib/x86_64-linux-gnu/libcuda.so",
        "--link",
        "libcuda.so.575.57.08::/usr/lib/x86_64-linux-gnu/libcuda.so.1",
        "--link",
        "libcudadebugger.so.575.57.08::/usr/lib/x86_64-linux-gnu/libcudadebugger.so.1",
        "--link",
        "libnvcuvid.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvcuvid.so.1",
        "--link",
        "libnvcuvid.so.1::/usr/lib/x86_64-linux-gnu/libnvcuvid.so",
        "--link",
        "libnvidia-allocator.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.1",
        "--link",
        "libnvidia-allocator.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-allocator.so",
        "--link",
        "libnvidia-cfg.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.1",
        "--link",
        "libnvidia-cfg.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-cfg.so",
        "--link",
        "libnvidia-encode.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-encode.so.1",
        "--link",
        "libnvidia-encode.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-encode.so",
        "--link",
        "libnvidia-fbc.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-fbc.so.1",
        "--link",
        "libnvidia-fbc.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-fbc.so",
        "--link",
        "libnvidia-ml.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-ml.so",
        "--link",
        "libnvidia-ngx.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-ngx.so.1",
        "--link",
        "libnvidia-nvvm.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.4",
        "--link",
        "libnvidia-nvvm.so.4::/usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so",
        "--link",
        "libnvidia-opencl.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.1",
        "--link",
        "libnvidia-opticalflow.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so",
        "--link",
        "libnvidia-opticalflow.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so.1",
        "--link",
        "libnvidia-ptxjitcompiler.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.1",
        "--link",
        "libnvidia-ptxjitcompiler.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so",
        "--link",
        "libnvidia-sandboxutils.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.1",
        "--link",
        "libnvidia-sandboxutils.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so",
        "--link",
        "libnvidia-vksc-core.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-vksc-core.so.1",
        "--link",
        "libnvoptix.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvoptix.so.1",
        "--link",
        "libvdpau_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/vdpau/libvdpau_nvidia.so.1"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "enable-cuda-compat",
        "--host-driver-version=575.57.08"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "update-ldcache",
        "--folder",
        "/usr/lib/x86_64-linux-gnu",
        "--folder",
        "/usr/lib/x86_64-linux-gnu/vdpau"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "disable-device-node-modification"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    }
  ]
}
```

### Generate and use CDI devices

```shell
root@nvidia-container-toolkit-1-19-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
time="2026-07-21T12:05:05Z" level=info msg="Using /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Using /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Auto-detected mode as 'nvml'"
time="2026-07-21T12:05:05Z" level=warning msg="failed to shutdown NVML: Uninitialized"
time="2026-07-21T12:05:05Z" level=warning msg="failed to shutdown NVML: Uninitialized"
time="2026-07-21T12:05:05Z" level=info msg="Using driver version 575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /dev/nvidia-modeset as /dev/nvidia-modeset"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate /dev/nvidia-uvm-tools: /dev/nvidia-uvm-tools: not found"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate /dev/nvidia-uvm: /dev/nvidia-uvm: not found"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /dev/nvidiactl as /dev/nvidiactl"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-egl-gbm.so.1.1.2 as /usr/lib/x86_64-linux-gnu/libnvidia-egl-gbm.so.1.1.2"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-egl-wayland.so.1.1.19 as /usr/lib/x86_64-linux-gnu/libnvidia-egl-wayland.so.1.1.19"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate libnvidia-vulkan-producer.so.575.57.08: libnvidia-vulkan-producer.so.575.57.08: not found\nlibnvidia-vulkan-producer.so.575.57.08: not found"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib64/xorg/modules/drivers/nvidia_drv.so as /usr/lib64/xorg/modules/drivers/nvidia_drv.so"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so.575.57.08 as /usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/share/glvnd/egl_vendor.d/10_nvidia.json as /usr/share/glvnd/egl_vendor.d/10_nvidia.json"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/15_nvidia_gbm.json as /usr/share/egl/egl_external_platform.d/15_nvidia_gbm.json"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json as /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/share/nvidia/nvoptix.bin as /usr/share/nvidia/nvoptix.bin"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate X11/xorg.conf.d/10-nvidia.conf: X11/xorg.conf.d/10-nvidia.conf: not found"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate X11/xorg.conf.d/nvidia-drm-outputclass.conf: X11/xorg.conf.d/nvidia-drm-outputclass.conf: not found"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /etc/vulkan/icd.d/nvidia_icd.json as /etc/vulkan/icd.d/nvidia_icd.json"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate vulkan/icd.d/nvidia_layers.json: vulkan/icd.d/nvidia_layers.json: not found\nvulkan/icd.d/nvidia_layers.json: not found"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /etc/vulkan/implicit_layer.d/nvidia_layers.json as /etc/vulkan/implicit_layer.d/nvidia_layers.json"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate vulkan/icd.d/nvidia_icd.x86_64.json: vulkan/icd.d/nvidia_icd.x86_64.json: not found\nvulkan/icd.d/nvidia_icd.x86_64.json: not found"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLESv2_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLESv2_nvidia.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libcuda.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libcuda.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libcudadebugger.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libcudadebugger.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvcuvid.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvcuvid.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-eglcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-eglcore.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-fbc.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-fbc.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glcore.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glsi.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glsi.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glvkspirv.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glvkspirv.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gpucomp.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gpucomp.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gtk2.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gtk2.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gtk3.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gtk3.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ngx.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ngx.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11-openssl3.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11-openssl3.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-present.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-present.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-rtcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-rtcore.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-tls.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-tls.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-vksc-core.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-vksc-core.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-wayland-client.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-wayland-client.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvoptix.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvoptix.so.575.57.08"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/vdpau/libvdpau_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/vdpau/libvdpau_nvidia.so.575.57.08"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate /nvidia-persistenced/socket: /nvidia-persistenced/socket: not found"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate /nvidia-fabricmanager/socket: /nvidia-fabricmanager/socket: not found"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate /tmp/nvidia-mps: /tmp/nvidia-mps: not found"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /lib/firmware/nvidia/575.57.08/gsp_ga10x.bin as /lib/firmware/nvidia/575.57.08/gsp_ga10x.bin"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /lib/firmware/nvidia/575.57.08/gsp_tu10x.bin as /lib/firmware/nvidia/575.57.08/gsp_tu10x.bin"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/bin/nvidia-smi as /usr/bin/nvidia-smi"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/bin/nvidia-debugdump as /usr/bin/nvidia-debugdump"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/bin/nvidia-persistenced as /usr/bin/nvidia-persistenced"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/bin/nvidia-cuda-mps-control as /usr/bin/nvidia-cuda-mps-control"
time="2026-07-21T12:05:05Z" level=info msg="Selecting /usr/bin/nvidia-cuda-mps-server as /usr/bin/nvidia-cuda-mps-server"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate nvidia-imex: nvidia-imex: not found"
time="2026-07-21T12:05:05Z" level=warning msg="Could not locate nvidia-imex-ctl: nvidia-imex-ctl: not found"
time="2026-07-21T12:05:05Z" level=info msg="Generated CDI spec with version 0.5.0"
root@nvidia-container-toolkit-1-19-0:~# nvidia-ctk cdi list
nvidia.com/gpu=0
nvidia.com/gpu=1
nvidia.com/gpu=2
nvidia.com/gpu=3
nvidia.com/gpu=GPU-0-FAKE-UUID
nvidia.com/gpu=GPU-1-FAKE-UUID
nvidia.com/gpu=GPU-2-FAKE-UUID
nvidia.com/gpu=GPU-3-FAKE-UUID
nvidia.com/gpu=all
time="2026-07-21T12:05:05Z" level=info msg="Found 9 CDI devices"
root@nvidia-container-toolkit-1-19-0:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
41f1b06f5246d8966758bcf0a47f0ec132b0b25e140911131cfa02db316dc051
root@nvidia-container-toolkit-1-19-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/41f1b06f5246d8966758bcf0a47f0ec132b0b25e140911131cfa02db316dc051/config.json | jq .hooks
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
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "create-symlinks",
        "--link",
        "libEGL_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0",
        "--link",
        "libGLESv1_CM_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.1",
        "--link",
        "libGLESv2_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLESv2_nvidia.so.2",
        "--link",
        "libGLX_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLX_indirect.so.0",
        "--link",
        "libGLX_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0",
        "--link",
        "libcuda.so.1::/usr/lib/x86_64-linux-gnu/libcuda.so",
        "--link",
        "libcuda.so.575.57.08::/usr/lib/x86_64-linux-gnu/libcuda.so.1",
        "--link",
        "libcudadebugger.so.575.57.08::/usr/lib/x86_64-linux-gnu/libcudadebugger.so.1",
        "--link",
        "libnvcuvid.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvcuvid.so.1",
        "--link",
        "libnvcuvid.so.1::/usr/lib/x86_64-linux-gnu/libnvcuvid.so",
        "--link",
        "libnvidia-allocator.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.1",
        "--link",
        "libnvidia-allocator.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-allocator.so",
        "--link",
        "libnvidia-cfg.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.1",
        "--link",
        "libnvidia-cfg.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-cfg.so",
        "--link",
        "libnvidia-encode.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-encode.so.1",
        "--link",
        "libnvidia-encode.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-encode.so",
        "--link",
        "libnvidia-fbc.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-fbc.so.1",
        "--link",
        "libnvidia-fbc.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-fbc.so",
        "--link",
        "libnvidia-ml.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-ml.so",
        "--link",
        "libnvidia-ngx.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-ngx.so.1",
        "--link",
        "libnvidia-nvvm.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.4",
        "--link",
        "libnvidia-nvvm.so.4::/usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so",
        "--link",
        "libnvidia-opencl.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.1",
        "--link",
        "libnvidia-opticalflow.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so",
        "--link",
        "libnvidia-opticalflow.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so.1",
        "--link",
        "libnvidia-ptxjitcompiler.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.1",
        "--link",
        "libnvidia-ptxjitcompiler.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so",
        "--link",
        "libnvidia-sandboxutils.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.1",
        "--link",
        "libnvidia-sandboxutils.so.1::/usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so",
        "--link",
        "libnvidia-vksc-core.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvidia-vksc-core.so.1",
        "--link",
        "libnvoptix.so.575.57.08::/usr/lib/x86_64-linux-gnu/libnvoptix.so.1",
        "--link",
        "libvdpau_nvidia.so.575.57.08::/usr/lib/x86_64-linux-gnu/vdpau/libvdpau_nvidia.so.1"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "enable-cuda-compat",
        "--host-driver-version=575.57.08"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
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
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "disable-device-node-modification"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    }
  ]
}
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-19-0:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-19-0:~# lsmod | grep fake
fake_nvidia_driver     12288  0
root@nvidia-container-toolkit-1-19-0:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
lrwxrwxrwx 1 root root  39 Jul 21 11:37 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so -> /lib/x86_64-linux-gnu/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  47 Jul 21 11:37 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 -> /lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root 31K Jul 21 11:37 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-19-0:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; preset: enabled)
     Active: inactive (dead) since Tue 2026-07-21 12:04:05 UTC; 59s ago
    Process: 669 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 669 (code=exited, status=0/SUCCESS)
        CPU: 9ms

Jul 21 12:04:05 nvidia-container-toolkit-1-19-0 systemd[1]: Starting fake-nvidia-device.service - Create device nodes for fake nvidia driver...
Jul 21 12:04:05 nvidia-container-toolkit-1-19-0 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jul 21 12:04:05 nvidia-container-toolkit-1-19-0 systemd[1]: Finished fake-nvidia-device.service - Create device nodes for fake nvidia driver.
```

### versions

```shell
root@nvidia-container-toolkit-1-19-0:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.19.0
commit: ec7b4e2fa2caecad6d89be4a26029b831fe7503a
root@nvidia-container-toolkit-1-19-0:~# docker --version
Docker version 28.2.0, build 879ac3f
root@nvidia-container-toolkit-1-19-0:~# containerd --version
containerd containerd.io 1.7.27 05044ec0a9a75232cad458027ca83437aae3f4da
root@nvidia-container-toolkit-1-19-0:~# cat /etc/os-release
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
root@nvidia-container-toolkit-1-19-0:~# uname -a
Linux nvidia-container-toolkit-1-19-0 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.19.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.19.0:ctr_v0.9.2
```
