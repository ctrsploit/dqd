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
time="2026-07-02T12:07:01Z" level=info msg="Using /usr/lib64/libnvidia-ml.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Auto-detected mode as 'nvml'"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /dev/nvidia0 as /dev/nvidia0"
time="2026-07-02T12:07:01Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x01-card; ignoring"
time="2026-07-02T12:07:01Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x01-render; ignoring"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /dev/nvidia1 as /dev/nvidia1"
time="2026-07-02T12:07:01Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x02-card; ignoring"
time="2026-07-02T12:07:01Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x02-render; ignoring"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /dev/nvidia2 as /dev/nvidia2"
time="2026-07-02T12:07:01Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x03-card; ignoring"
time="2026-07-02T12:07:01Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x03-render; ignoring"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /dev/nvidia3 as /dev/nvidia3"
time="2026-07-02T12:07:01Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x04-card; ignoring"
time="2026-07-02T12:07:01Z" level=warning msg="Failed to evaluate symlink /dev/dri/by-path/pci-\x04-render; ignoring"
time="2026-07-02T12:07:01Z" level=info msg="Using driver version 575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /dev/nvidia-modeset as /dev/nvidia-modeset"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate /dev/nvidia-uvm-tools: pattern /dev/nvidia-uvm-tools not found"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate /dev/nvidia-uvm: pattern /dev/nvidia-uvm not found"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /dev/nvidiactl as /dev/nvidiactl"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-egl-gbm.so.1.1.2 as /usr/lib64/libnvidia-egl-gbm.so.1.1.2"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-egl-wayland.so.1.1.19 as /usr/lib64/libnvidia-egl-wayland.so.1.1.19"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-allocator.so.575.57.08 as /usr/lib64/libnvidia-allocator.so.575.57.08"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate libnvidia-vulkan-producer.so.575.57.08: pattern libnvidia-vulkan-producer.so.575.57.08 not found\nlibnvidia-vulkan-producer.so.575.57.08: not found"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/xorg/modules/drivers/nvidia_drv.so as /usr/lib64/xorg/modules/drivers/nvidia_drv.so"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so.575.57.08 as /usr/lib64/xorg/modules/extensions/libglxserver_nvidia.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/share/glvnd/egl_vendor.d/10_nvidia.json as /usr/share/glvnd/egl_vendor.d/10_nvidia.json"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/15_nvidia_gbm.json as /usr/share/egl/egl_external_platform.d/15_nvidia_gbm.json"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json as /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/share/nvidia/nvoptix.bin as /usr/share/nvidia/nvoptix.bin"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate X11/xorg.conf.d/10-nvidia.conf: pattern X11/xorg.conf.d/10-nvidia.conf not found"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate X11/xorg.conf.d/nvidia-drm-outputclass.conf: pattern X11/xorg.conf.d/nvidia-drm-outputclass.conf not found"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /etc/vulkan/icd.d/nvidia_icd.json as /etc/vulkan/icd.d/nvidia_icd.json"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate vulkan/icd.d/nvidia_layers.json: pattern vulkan/icd.d/nvidia_layers.json not found\npattern vulkan/icd.d/nvidia_layers.json not found"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /etc/vulkan/implicit_layer.d/nvidia_layers.json as /etc/vulkan/implicit_layer.d/nvidia_layers.json"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libEGL_nvidia.so.575.57.08 as /usr/lib64/libEGL_nvidia.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libGLESv1_CM_nvidia.so.575.57.08 as /usr/lib64/libGLESv1_CM_nvidia.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libGLESv2_nvidia.so.575.57.08 as /usr/lib64/libGLESv2_nvidia.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libGLX_nvidia.so.575.57.08 as /usr/lib64/libGLX_nvidia.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libcuda.so.575.57.08 as /usr/lib64/libcuda.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libcudadebugger.so.575.57.08 as /usr/lib64/libcudadebugger.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvcuvid.so.575.57.08 as /usr/lib64/libnvcuvid.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-allocator.so.575.57.08 as /usr/lib64/libnvidia-allocator.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-cfg.so.575.57.08 as /usr/lib64/libnvidia-cfg.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-eglcore.so.575.57.08 as /usr/lib64/libnvidia-eglcore.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-encode.so.575.57.08 as /usr/lib64/libnvidia-encode.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-fbc.so.575.57.08 as /usr/lib64/libnvidia-fbc.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-glcore.so.575.57.08 as /usr/lib64/libnvidia-glcore.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-glsi.so.575.57.08 as /usr/lib64/libnvidia-glsi.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-glvkspirv.so.575.57.08 as /usr/lib64/libnvidia-glvkspirv.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-gpucomp.so.575.57.08 as /usr/lib64/libnvidia-gpucomp.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-gtk2.so.575.57.08 as /usr/lib64/libnvidia-gtk2.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-gtk3.so.575.57.08 as /usr/lib64/libnvidia-gtk3.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-ml.so.575.57.08 as /usr/lib64/libnvidia-ml.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-ngx.so.575.57.08 as /usr/lib64/libnvidia-ngx.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-nvvm.so.575.57.08 as /usr/lib64/libnvidia-nvvm.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-opencl.so.575.57.08 as /usr/lib64/libnvidia-opencl.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-opticalflow.so.575.57.08 as /usr/lib64/libnvidia-opticalflow.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-pkcs11-openssl3.so.575.57.08 as /usr/lib64/libnvidia-pkcs11-openssl3.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-pkcs11.so.575.57.08 as /usr/lib64/libnvidia-pkcs11.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-present.so.575.57.08 as /usr/lib64/libnvidia-present.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-ptxjitcompiler.so.575.57.08 as /usr/lib64/libnvidia-ptxjitcompiler.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-rtcore.so.575.57.08 as /usr/lib64/libnvidia-rtcore.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-sandboxutils.so.575.57.08 as /usr/lib64/libnvidia-sandboxutils.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-tls.so.575.57.08 as /usr/lib64/libnvidia-tls.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-vksc-core.so.575.57.08 as /usr/lib64/libnvidia-vksc-core.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvidia-wayland-client.so.575.57.08 as /usr/lib64/libnvidia-wayland-client.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/libnvoptix.so.575.57.08 as /usr/lib64/libnvoptix.so.575.57.08"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/lib64/vdpau/libvdpau_nvidia.so.575.57.08 as /usr/lib64/vdpau/libvdpau_nvidia.so.575.57.08"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate /nvidia-persistenced/socket: pattern /nvidia-persistenced/socket not found"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate /nvidia-fabricmanager/socket: pattern /nvidia-fabricmanager/socket not found"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate /tmp/nvidia-mps: pattern /tmp/nvidia-mps not found"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /lib/firmware/nvidia/575.57.08/gsp_ga10x.bin as /lib/firmware/nvidia/575.57.08/gsp_ga10x.bin"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /lib/firmware/nvidia/575.57.08/gsp_tu10x.bin as /lib/firmware/nvidia/575.57.08/gsp_tu10x.bin"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/bin/nvidia-smi as /usr/bin/nvidia-smi"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/bin/nvidia-debugdump as /usr/bin/nvidia-debugdump"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/bin/nvidia-persistenced as /usr/bin/nvidia-persistenced"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/bin/nvidia-cuda-mps-control as /usr/bin/nvidia-cuda-mps-control"
time="2026-07-02T12:07:01Z" level=info msg="Selecting /usr/bin/nvidia-cuda-mps-server as /usr/bin/nvidia-cuda-mps-server"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate nvidia-imex: pattern nvidia-imex not found"
time="2026-07-02T12:07:01Z" level=warning msg="Could not locate nvidia-imex-ctl: pattern nvidia-imex-ctl not found"
time="2026-07-02T12:07:01Z" level=info msg="Generated CDI spec with version 0.8.0"
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# nvidia-ctk cdi list
time="2026-07-02T12:07:01Z" level=info msg="Found 9 CDI devices"
nvidia.com/gpu=0
nvidia.com/gpu=1
nvidia.com/gpu=2
nvidia.com/gpu=3
nvidia.com/gpu=GPU-0-FAKE-UUID
nvidia.com/gpu=GPU-1-FAKE-UUID
nvidia.com/gpu=GPU-2-FAKE-UUID
nvidia.com/gpu=GPU-3-FAKE-UUID
nvidia.com/gpu=all
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# rm -f /tmp/nct-podman.cid
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# podman run -tid --cidfile /tmp/nct-podman.cid --device nvidia.com/gpu=all busybox
time="2026-07-02T12:07:01Z" level=warning msg="The input device is not a TTY. The --tty and --interactive flags might not work properly"
Resolved "busybox" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull docker.io/library/busybox:latest...
Getting image source signatures
Copying blob sha256:b05093807bb0294152bb9cf86d64da722732dddaf7f8882fa1f120477dbc4db3
Copying config sha256:c6348fa86ba0fb2108c9334f5fe913ddc6d853313e655891f133a0127c30099f
Writing manifest to image destination
cb2c3e9b2af07c880ec35d58d9c6612ca29c49fb09b36761380022ed0be554bd
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# cat /run/crun/$(cat /tmp/nct-podman.cid)/config.json | jq .hooks
{
  "createContainer": [
    {
      "path": "/usr/bin/nvidia-cdi-hook",
      "args": [
        "nvidia-cdi-hook",
        "create-symlinks",
        "--link",
        "../libnvidia-allocator.so.1::/usr/lib64/gbm/nvidia-drm_gbm.so",
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
        "libcuda.so.1::/usr/lib64/libcuda.so",
        "--link",
        "libnvidia-opticalflow.so.1::/usr/lib64/libnvidia-opticalflow.so",
        "--link",
        "libGLX_nvidia.so.575.57.08::/usr/lib64/libGLX_indirect.so.0"
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
        "/usr/lib64",
        "--folder",
        "/usr/lib64/vdpau"
      ]
    }
  ]
}
```

### Inspect fake NVIDIA devices

```shell
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# lsmod | grep fake
fake_nvidia_driver     12288  0
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# ls -lah /usr/lib64/libnvidia-ml.so*
lrwxrwxrwx 1 root root  31 Jul  2 11:43 /usr/lib64/libnvidia-ml.so -> /usr/../lib64/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  39 Jul  2 11:43 /usr/lib64/libnvidia-ml.so.1 -> /usr/../lib64/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root 22K Jul  2 11:43 /usr/lib64/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; preset: disabled)
     Active: inactive (dead) since Thu 2026-07-02 12:00:48 UTC; 6min ago
    Process: 606 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 606 (code=exited, status=0/SUCCESS)
        CPU: 10ms

Jul 02 12:00:48 nvidia-container-toolkit-1-17-6-podman-5-5-1 systemd[1]: Starting Create device nodes for fake nvidia driver...
Jul 02 12:00:48 nvidia-container-toolkit-1-17-6-podman-5-5-1 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jul 02 12:00:48 nvidia-container-toolkit-1-17-6-podman-5-5-1 systemd[1]: Finished Create device nodes for fake nvidia driver.
```

### versions

```shell
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.17.6
commit: e627eb2e21e167988e04c0579a1c941c1e263ff6
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# crun --version
crun version 1.28
commit: 54f16ffbefcd022bf032af768b5c5ce075c18bfc
rundir: /run/user/0/crun
spec: 1.0.0
+SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +JSON_C
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# podman info
host:
  arch: amd64
  buildahVersion: 1.40.1
  cgroupControllers:
  - cpuset
  - cpu
  - io
  - memory
  - hugetlb
  - pids
  - rdma
  - misc
  cgroupManager: systemd
  cgroupVersion: v2
  conmon:
    package: conmon-2.2.1-2.el9.x86_64
    path: /usr/bin/conmon
    version: 'conmon version 2.2.1, commit: '
  cpuUtilization:
    idlePercent: 99.31
    systemPercent: 0.43
    userPercent: 0.26
  cpus: 2
  databaseBackend: sqlite
  distribution:
    distribution: centos
    version: "9"
  eventLogger: journald
  freeLocks: 2047
  hostname: nvidia-container-toolkit-1-17-6-podman-5-5-1
  idMappings:
    gidmap: null
    uidmap: null
  kernel: 5.14.0-601.el9.x86_64
  linkmode: dynamic
  logDriver: journald
  memFree: 1673076736
  memTotal: 2058506240
  networkBackend: netavark
  networkBackendInfo:
    backend: netavark
    dns:
      package: aardvark-dns-1.17.0-1.el9.x86_64
      path: /usr/libexec/podman/aardvark-dns
      version: aardvark-dns 1.17.0
    package: netavark-1.17.2-1.el9.x86_64
    path: /usr/libexec/podman/netavark
    version: netavark 1.17.2
  ociRuntime:
    name: crun
    package: crun-1.28-1.el9.x86_64
    path: /usr/bin/crun
    version: |-
      crun version 1.28
      commit: 54f16ffbefcd022bf032af768b5c5ce075c18bfc
      rundir: /run/user/0/crun
      spec: 1.0.0
      +SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +JSON_C
  os: linux
  pasta:
    executable: /usr/bin/pasta
    package: passt-0^20260611.ga9c61ff-1.el9.x86_64
    version: |
      pasta 0^20260611.ga9c61ff-1.el9.x86_64
      Copyright Red Hat
      GNU General Public License, version 2 or later
        <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
      This is free software: you are free to change and redistribute it.
      There is NO WARRANTY, to the extent permitted by law.
  remoteSocket:
    exists: true
    path: /run/podman/podman.sock
  rootlessNetworkCmd: pasta
  security:
    apparmorEnabled: false
    capabilities: CAP_CHOWN,CAP_DAC_OVERRIDE,CAP_FOWNER,CAP_FSETID,CAP_KILL,CAP_NET_BIND_SERVICE,CAP_SETFCAP,CAP_SETGID,CAP_SETPCAP,CAP_SETUID,CAP_SYS_CHROOT
    rootless: false
    seccompEnabled: true
    seccompProfilePath: /usr/share/containers/seccomp.json
    selinuxEnabled: false
  serviceIsRemote: false
  slirp4netns:
    executable: /usr/bin/slirp4netns
    package: slirp4netns-1.3.3-1.el9.x86_64
    version: |-
      slirp4netns version 1.3.3
      commit: 944fa94090e1fd1312232cbc0e6b43585553d824
      libslirp: 4.4.0
      SLIRP_CONFIG_VERSION_MAX: 3
      libseccomp: 2.5.2
  swapFree: 0
  swapTotal: 0
  uptime: 0h 6m 23.00s
  variant: ""
plugins:
  authorization: null
  log:
  - k8s-file
  - none
  - passthrough
  - journald
  network:
  - bridge
  - macvlan
  - ipvlan
  volume:
  - local
registries:
  search:
  - registry.access.redhat.com
  - registry.redhat.io
  - docker.io
store:
  configFile: /etc/containers/storage.conf
  containerStore:
    number: 1
    paused: 0
    running: 1
    stopped: 0
  graphDriverName: overlay
  graphOptions:
    overlay.mountopt: nodev,metacopy=on
  graphRoot: /var/lib/containers/storage
  graphRootAllocated: 10462973952
  graphRootUsed: 2755821568
  graphStatus:
    Backing Filesystem: extfs
    Native Overlay Diff: "false"
    Supports d_type: "true"
    Supports shifting: "true"
    Supports volatile: "true"
    Using metacopy: "true"
  imageCopyTmpDir: /var/tmp
  imageStore:
    number: 1
  runRoot: /run/containers/storage
  transientStore: false
  volumePath: /var/lib/containers/storage/volumes
version:
  APIVersion: 5.5.1
  Built: 1749565945
  BuiltTime: Tue Jun 10 14:32:25 2025
  GitCommit: ""
  GoVersion: go1.24.3 (Red Hat 1.24.3-3.el9)
  Os: linux
  OsArch: linux/amd64
  Version: 5.5.1
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# cat /etc/os-release
NAME="CentOS Stream"
VERSION="9"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="9"
PLATFORM_ID="platform:el9"
PRETTY_NAME="CentOS Stream 9"
ANSI_COLOR="0;31"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:centos:centos:9"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://issues.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 9"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
root@nvidia-container-toolkit-1-17-6-podman-5-5-1:~# uname -a
Linux nvidia-container-toolkit-1-17-6-podman-5-5-1 5.14.0-601.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Jul 22 15:32:41 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.17.6-podman-v5.5.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.17.6-podman-v5.5.1:ctr_v0.1.0
```
