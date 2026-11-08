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

### verify

The published ctr image can be checked without booting a VM:

```shell
$ docker run --rm ghcr.io/ctrsploit/nvidia-driver-580.105.08:ctr_v0.1.0 sh -c '
    ls /lib/modules
    cd /opt/nvidia/580.105.08 && sha256sum -c SHA256SUMS
    modinfo -F version nvidia.ko && modinfo -F version nvidia-uvm.ko
    modinfo -F vermagic nvidia.ko
    ls -lh /lib/firmware/nvidia/580.105.08/
    modprobe -S 6.8.0-101-generic -n ecc && echo ecc-ok'
6.8.0-101-generic
nvidia.ko: OK
nvidia-uvm.ko: OK
580.105.08
580.105.08
6.8.0-101-generic SMP preempt mod_unload modversions
-rw-r--r-- 1 root root  72M Nov  6 09:48 gsp_ga10x.bin
-rw-r--r-- 1 root root  29M Nov  6 09:48 gsp_tu10x.bin
ecc-ok
```

Note on `SHA256SUMS`: the digests are self-consistent per image but are **not
stable across rebuilds**. The driver bakes its build path into the modules via
`__FILE__`, and the extraction directory is a random `mktemp` name, so two
builds of the same inputs produce different module digests (the `ctr_v0.1.0`
build carries `836f1dbe…` / `e0c5ec3f…` for `nvidia.ko` / `nvidia-uvm.ko`).
Component identity is pinned by the package sha256 in `SOURCES.md` plus the
`modinfo` version/vermagic above, not by the module digests.

## build

```shell
make ctr ENV=nvidia-driver/580.105.08
```

### for developers

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-driver-580.105.08:ctr_v0.1.0
```
