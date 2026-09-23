# nvidia-container-toolkit v1.20.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:latest | points to `v0.1.1` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:v0.1.1 | bump fake-nvidia to v0.9.0-beta.1 (module registers as `nvidia`, CDI spec auto-generated at boot); nvidia-container-toolkit 1.20.1 |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:v0.1.0 | superseded by `v0.1.1`; fake-nvidia v0.8.3 (module `fake_nvidia_driver`, CDI spec required manual `nvidia-ctk cdi generate`) |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:ctr_v0.1.1 | install real nvidia driver without kernel module; install i386 libs; fake-nvidia v0.9.0-beta.1; nvidia-container-toolkit 1.20.1 |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:ctr_v0.1.0 | superseded by `ctr_v0.1.1`; fake-nvidia v0.8.3 |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.20.1
$ ssh dqd-nvidia-container-toolkit-v1.20.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.20.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with the NVIDIA runtime

```shell
root@nvidia-container-toolkit-1-20-1:~# docker run -tid --runtime=nvidia --gpus=all busybox
41f84c82cca759eb2403aae91a4b786c7681454cd9b123b37fd0c08d724f504a
root@nvidia-container-toolkit-1-20-1:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/41f84c82cca759eb2403aae91a4b786c7681454cd9b123b37fd0c08d724f504a/config.json | jq .hooks
{
  "createRuntime": [
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-0-FAKE-UUID"
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
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-1-FAKE-UUID"
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
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-2-FAKE-UUID"
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
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-3-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    }
  ],
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
    },
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "update-application-profile"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    }
  ]
}
```

### Generate and use CDI devices

At boot `nvidia-cdi-refresh.service` already generates `/var/run/cdi/nvidia.yaml` (see the previous section), so `docker run --device nvidia.com/gpu=all` works out of the box. The manual `nvidia-ctk cdi generate` below writes a second spec to `/etc/cdi/nvidia.yaml` and shows what generation walks through; `nvidia-ctk cdi list` merges both files.

```shell
root@nvidia-container-toolkit-1-20-1:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
time="2026-09-21T03:22:39Z" level=info msg="Using /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Using /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Auto-detected mode as 'nvml'"
time="2026-09-21T03:22:39Z" level=warning msg="failed to shutdown NVML: Uninitialized"
time="2026-09-21T03:22:39Z" level=warning msg="failed to shutdown NVML: Uninitialized"
time="2026-09-21T03:22:39Z" level=info msg="Using driver version 575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /dev/nvidia-modeset as /dev/nvidia-modeset"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate /dev/nvidia-uvm-tools: /dev/nvidia-uvm-tools: not found"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate /dev/nvidia-uvm: /dev/nvidia-uvm: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /dev/nvidiactl as /dev/nvidiactl"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-egl-gbm.so.1.1.2 as /usr/lib/x86_64-linux-gnu/libnvidia-egl-gbm.so.1.1.2"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-egl-wayland.so.1.1.19 as /usr/lib/x86_64-linux-gnu/libnvidia-egl-wayland.so.1.1.19"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate libnvidia-egl-wayland2.so.*.*: libnvidia-egl-wayland2.so.*.*: not found\nlibnvidia-egl-wayland2.so.*.*: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-egl-xcb.so.1.0.2 as /usr/lib/x86_64-linux-gnu/libnvidia-egl-xcb.so.1.0.2"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-egl-xlib.so.1.0.2 as /usr/lib/x86_64-linux-gnu/libnvidia-egl-xlib.so.1.0.2"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate libnvidia-vulkan-producer.so.575.57.08: libnvidia-vulkan-producer.so.575.57.08: not found\nlibnvidia-vulkan-producer.so.575.57.08: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib64/xorg/modules/drivers/nvidia_drv.so as /usr/lib64/xorg/modules/drivers/nvidia_drv.so"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so.575.57.08 as /usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/bin/nvidia-xconfig as /usr/bin/nvidia-xconfig"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/share/glvnd/egl_vendor.d/10_nvidia.json as /usr/share/glvnd/egl_vendor.d/10_nvidia.json"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/15_nvidia_gbm.json as /usr/share/egl/egl_external_platform.d/15_nvidia_gbm.json"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json as /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate egl/egl_external_platform.d/09_nvidia_wayland2.json: egl/egl_external_platform.d/09_nvidia_wayland2.json: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/20_nvidia_xcb.json as /usr/share/egl/egl_external_platform.d/20_nvidia_xcb.json"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/20_nvidia_xlib.json as /usr/share/egl/egl_external_platform.d/20_nvidia_xlib.json"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/share/nvidia/nvoptix.bin as /usr/share/nvidia/nvoptix.bin"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate X11/xorg.conf.d/10-nvidia.conf: X11/xorg.conf.d/10-nvidia.conf: not found"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate X11/xorg.conf.d/nvidia-drm-outputclass.conf: X11/xorg.conf.d/nvidia-drm-outputclass.conf: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /etc/OpenCL/vendors/nvidia.icd as /etc/OpenCL/vendors/nvidia.icd"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /etc/vulkan/icd.d/nvidia_icd.json as /etc/vulkan/icd.d/nvidia_icd.json"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate vulkan/icd.d/nvidia_layers.json: vulkan/icd.d/nvidia_layers.json: not found\nvulkan/icd.d/nvidia_layers.json: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /etc/vulkan/implicit_layer.d/nvidia_layers.json as /etc/vulkan/implicit_layer.d/nvidia_layers.json"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate vulkan/icd.d/nvidia_icd.x86_64.json: vulkan/icd.d/nvidia_icd.x86_64.json: not found\nvulkan/icd.d/nvidia_icd.x86_64.json: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLESv2_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLESv2_nvidia.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libcuda.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libcuda.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libcudadebugger.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libcudadebugger.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvcuvid.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvcuvid.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-allocator.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-eglcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-eglcore.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-fbc.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-fbc.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glcore.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glsi.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glsi.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-glvkspirv.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-glvkspirv.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gpucomp.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gpucomp.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gtk2.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gtk2.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-gtk3.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-gtk3.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ngx.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ngx.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11-openssl3.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11-openssl3.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-pkcs11.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-present.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-present.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-rtcore.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-rtcore.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-sandboxutils.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-tls.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-tls.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-vksc-core.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-vksc-core.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-wayland-client.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvidia-wayland-client.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvoptix.so.575.57.08 as /usr/lib/x86_64-linux-gnu/libnvoptix.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/vdpau/libvdpau_nvidia.so.575.57.08 as /usr/lib/x86_64-linux-gnu/vdpau/libvdpau_nvidia.so.575.57.08"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/lib/x86_64-linux-gnu/libnvidia-nvvm70.so.4 as /usr/lib/x86_64-linux-gnu/libnvidia-nvvm70.so.4"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate /nvidia-persistenced/socket: /nvidia-persistenced/socket: not found"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate /nvidia-fabricmanager/socket: /nvidia-fabricmanager/socket: not found"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate /tmp/nvidia-mps: /tmp/nvidia-mps: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /lib/firmware/nvidia/575.57.08/gsp_ga10x.bin as /lib/firmware/nvidia/575.57.08/gsp_ga10x.bin"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /lib/firmware/nvidia/575.57.08/gsp_tu10x.bin as /lib/firmware/nvidia/575.57.08/gsp_tu10x.bin"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate nvidia/575.57.08/ucodes*.bin: nvidia/575.57.08/ucodes*.bin: not found"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/bin/nvidia-smi as /usr/bin/nvidia-smi"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/bin/nvidia-debugdump as /usr/bin/nvidia-debugdump"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/bin/nvidia-persistenced as /usr/bin/nvidia-persistenced"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/bin/nvidia-cuda-mps-control as /usr/bin/nvidia-cuda-mps-control"
time="2026-09-21T03:22:39Z" level=info msg="Selecting /usr/bin/nvidia-cuda-mps-server as /usr/bin/nvidia-cuda-mps-server"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate nvidia-imex: nvidia-imex: not found"
time="2026-09-21T03:22:39Z" level=warning msg="Could not locate nvidia-imex-ctl: nvidia-imex-ctl: not found"
time="2026-09-21T03:22:39Z" level=info msg="Generated CDI spec with version 0.5.0"
root@nvidia-container-toolkit-1-20-1:~# nvidia-ctk cdi list
nvidia.com/gpu=0
nvidia.com/gpu=1
nvidia.com/gpu=2
nvidia.com/gpu=3
nvidia.com/gpu=GPU-0-FAKE-UUID
nvidia.com/gpu=GPU-1-FAKE-UUID
nvidia.com/gpu=GPU-2-FAKE-UUID
nvidia.com/gpu=GPU-3-FAKE-UUID
nvidia.com/gpu=all
time="2026-09-21T03:22:45Z" level=info msg="Found 9 CDI devices"
root@nvidia-container-toolkit-1-20-1:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all busybox
20a0fbd0d974b8f84ce97f7c8da1d99fde201b7a4ab39400330e913dd5d9f71d
root@nvidia-container-toolkit-1-20-1:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/20a0fbd0d974b8f84ce97f7c8da1d99fde201b7a4ab39400330e913dd5d9f71d/config.json | jq .hooks
{
  "createRuntime": [
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-0-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-1-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-2-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-3-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
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
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "update-application-profile"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    }
  ]
}
```

```shell
root@nvidia-container-toolkit-1-20-1:~# docker run -tid --runtime=nvidia --device nvidia.com/gpu=all busybox
5650654a314a07f9660b06aa73aa3f229572398d0e2d17bcf067eb23cbc74843
root@nvidia-container-toolkit-1-20-1:~# docker exec 5650654a314a ls -l /dev/nvidia*
crw-rw-rw-    1 root     root      195, 254 Sep 22 02:51 /dev/nvidia-modeset
crw-rw-rw-    1 root     root      195,   0 Sep 22 02:51 /dev/nvidia0
crw-rw-rw-    1 root     root      195,   1 Sep 22 02:51 /dev/nvidia1
crw-rw-rw-    1 root     root      195,   2 Sep 22 02:51 /dev/nvidia2
crw-rw-rw-    1 root     root      195,   3 Sep 22 02:51 /dev/nvidia3
crw-rw-rw-    1 root     root      195, 255 Sep 22 02:51 /dev/nvidiactl
root@nvidia-container-toolkit-1-20-1:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/5650654a314a07f9660b06aa73aa3f229572398d0e2d17bcf067eb23cbc74843/config.json | jq .hooks
{
  "createRuntime": [
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-0-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-1-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-2-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "apply-cuda-memory-limits",
        "--driver-root",
        "",
        "--gpu-id",
        "GPU-3-FAKE-UUID"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
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
    },
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "update-application-profile"
      ],
      "env": [
        "NVIDIA_CTK_DEBUG=false"
      ]
    }
  ]
}
```

### Inspect the CDI auto-refresh mechanism

Since fake-nvidia v0.9.0-beta.1 the kernel module registers under the name `nvidia` (was `fake_nvidia_driver` in v0.1.0), so both identity checks of the auto-refresh mechanism match: the udev rule below fires on the module-add event at boot, and the `ExecCondition` grep finds `nvidia.ko` in `modules.dep`. `nvidia-cdi-refresh.service` therefore generates `/var/run/cdi/nvidia.yaml` automatically at boot — no manual `nvidia-ctk cdi generate` needed.

```shell
root@nvidia-container-toolkit-1-20-1:~# systemctl status nvidia-cdi-refresh.service
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-1:~# systemctl show -p ExecCondition nvidia-cdi-refresh.service
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-1:~# grep -E "/(nvidia|nvidia-current)[.]ko" /lib/modules/$(uname -r)/modules.dep
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-1:~# modinfo nvidia
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-1:~# systemctl show -p Environment nvidia-cdi-refresh.service
Environment=NVIDIA_CTK_CDI_OUTPUT_FILE_PATH=/var/run/cdi/nvidia.yaml
root@nvidia-container-toolkit-1-20-1:~# systemctl status nvidia-cdi-refresh.path
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-1:~# grep ^ACTION /lib/udev/rules.d/99-nvidia-cdi-refresh.rules
ACTION=="add", SUBSYSTEM=="module", KERNEL=="nvidia|nvidia_current", TAG+="systemd", ENV{SYSTEMD_WANTS}+="nvidia-cdi-refresh.service"
root@nvidia-container-toolkit-1-20-1:~# ls /etc/cdi /var/run/cdi
<!-- VERIFY -->
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-20-1:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-20-1:~# lsmod | grep nvidia
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-1:~# nvidia-smi -L
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-1:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-20-1:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-20-1:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.20.1
commit: dffc40b4f820ce5c512633bac9e0418d0e05a2ee
root@nvidia-container-toolkit-1-20-1:~# docker --version
Docker version 28.2.0, build 879ac3f
root@nvidia-container-toolkit-1-20-1:~# containerd --version
containerd containerd.io 1.7.27 05044ec0a9a75232cad458027ca83437aae3f4da
root@nvidia-container-toolkit-1-20-1:~# cat /etc/os-release
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
root@nvidia-container-toolkit-1-20-1:~# uname -a
Linux nvidia-container-toolkit-1-20-1 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.20.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.20.1:ctr_v0.1.1
```
