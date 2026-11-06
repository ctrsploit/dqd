# NVIDIA open kernel driver 580.105.08

| type | image | note |
| ---- | ----- | ---- |
| ctr | ghcr.io/ctrsploit/nvidia-driver-580.105.08:ctr_v0.1.0 | Ubuntu 24.04 + kernel 6.8.0-101-generic + unmodified open kernel modules |

Component image for GPU-less NVIDIA driver labs. It carries the real, unmodified
open kernel modules built from NVIDIA's official package against a pinned Ubuntu
kernel, plus the GSP firmware from that same package.

- No `.run` installer is run, no DKMS, no userspace driver library (no CUDA).
- Modules are compiled at image build time, so the kernel and the modules can
  never drift apart inside the lab VM.
- 580.105.08 is the vulnerable build for CVE-2026-47595 (fixed in 580.178.04).
  The fix counterpart is a separate component image, not a module swap.

| path | contents |
| ---- | -------- |
| `/opt/nvidia/580.105.08/nvidia.ko` | open kernel module |
| `/opt/nvidia/580.105.08/nvidia-uvm.ko` | UVM module |
| `/opt/nvidia/580.105.08/SHA256SUMS` | module digests |
| `/opt/nvidia/580.105.08/SOURCES.md` | package URL, sha256 and build command |
| `/lib/firmware/nvidia/580.105.08/gsp_*.bin` | GSP firmware from the package |
| `/usr/src/linux-headers-6.8.0-101-generic` | headers, kept for child layers |

The kernel is installed from the Ubuntu security pool so the exact
`6.8.0-101.101` ABI stays downloadable after it leaves the apt indexes. An
environment built on this image must set `KERNEL=false`; otherwise d2vm installs
a different kernel and the prebuilt modules no longer match it.

## build

```shell
make ctr ENV=nvidia-driver/580.105.08
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-driver-580.105.08:ctr_v0.1.0
```
