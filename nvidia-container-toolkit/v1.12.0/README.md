# nvidia-container-toolkit v1.12.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.12.0:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.12.0:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.12.0_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.12.0:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.12.0_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.12.0
$ ssh dqd-nvidia-container-toolkit-v1.12.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.12.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

https://web.archive.org/web/20230627162323/https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-12-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
3ced7c4811483f62c13ca12b92be377c0b5cdcab9e5e4ab810d96ecc4208ffdf
root@nvidia-container-toolkit-1-12-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/3ced7c4811483f62c13ca12b92be377c0b5cdcab9e5e4ab810d96ecc4208ffdf/config.json | jq .hooks
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
      "path": "/proc/304/exe",
      "args": [
        "libnetwork-setkey",
        "-exec-root=/var/run/docker",
        "3ced7c4811483f62c13ca12b92be377c0b5cdcab9e5e4ab810d96ecc4208ffdf",
        "30c65e50c61d"
      ]
    }
  ]
}
```

### CDI mode

The `l.logger` field in v1.12.0, which was left uninitialized and could cause a panic, was fixed in [v1.13.0-rc.3](https://github.com/NVIDIA/nvidia-container-toolkit/commit/b2aaa21b0a1a4a9631f58bdd44bb678e15093b15).

https://github.com/NVIDIA/nvidia-container-toolkit/blob/v1.12.0/internal/lookup/library.go#L36-L68

```go
func NewLibraryLocator(logger *log.Logger, root string) (Locator, error) {
	...
	l := library{
		symlink: NewSymlinkLocator(logger, root),
		cache:   cache,
	}

	return &l, nil
}

// Locate finds the specified libraryname.
func (l library) Locate(libname string) ([]string, error) {
	...
	paths32, paths64 := l.cache.Lookup(libname)
	if len(paths32) > 0 {
		l.logger.Warnf("Ignoring 32-bit libraries for %v: %v", libname, paths32)
	}
  ...
}
```

```shell
root@nvidia-container-toolkit-1-12-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
WARN[0000] Failed to locate : pattern  not found        
INFO[0000] Selecting /dev/nvidia0 as /dev/nvidia0       
WARN[0000] Failed to evaluate symlink /dev/dri/by-path/pci--card; ignoring 
...
INFO[0000] Selecting /dev/nvidia3 as /dev/nvidia3       
WARN[0000] Could not locate /var/run/nvidia-persistenced/socket: pattern /var/run/nvidia-persistenced/socket not found 
WARN[0000] Could not locate /var/run/nvidia-fabricmanager/socket: pattern /var/run/nvidia-fabricmanager/socket not found 
WARN[0000] Could not locate /tmp/nvidia-mps: pattern /tmp/nvidia-mps not found 
INFO[0000] Using driver version 575.57.08               
...
INFO[0000] Selecting /dev/nvidiactl as /dev/nvidiactl   
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x2c pc=0x512482]

goroutine 1 [running]:
github.com/sirupsen/logrus.(*Logger).Logf(0xc00019fa30?, 0x1?, {0x6afab6?, 0x1?}, {0xc00010e868?, 0x203000?, 0x203000?})
	/go/src/nvidia-container-toolkit/vendor/github.com/sirupsen/logrus/logger.go:152 +0x22
github.com/sirupsen/logrus.(*Logger).Warnf(...)
	/go/src/nvidia-container-toolkit/vendor/github.com/sirupsen/logrus/logger.go:178
github.com/NVIDIA/nvidia-container-toolkit/internal/lookup.library.Locate({0x0, {0x6fd1f8, 0xc000080870}, {0x6fd7a0, 0xc0000cd540}}, {0x6a8592, 0x14})
	/go/src/nvidia-container-toolkit/internal/lookup/library.go:60 +0x1ab
...
main.main()
	/go/src/nvidia-container-toolkit/cmd/nvidia-ctk/main.go:85 +0x445
```

The workaround is deleting `/lib/i386-linux-gnu/libnvidia-egl-gbm.so.1`.

```shell
root@nvidia-container-toolkit-1-12-0:~# rm /lib/i386-linux-gnu/libnvidia-egl-gbm.so.1
root@nvidia-container-toolkit-1-12-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
WARN[0000] Failed to locate : pattern  not found        
INFO[0000] Selecting /dev/nvidia0 as /dev/nvidia0       
WARN[0000] Failed to evaluate symlink /dev/dri/by-path/pci--card; ignoring 
...
INFO[0000] Selecting /dev/nvidia3 as /dev/nvidia3       
WARN[0000] Could not locate /var/run/nvidia-persistenced/socket 
WARN[0000] Could not locate /var/run/nvidia-fabricmanager/socket 
WARN[0000] Could not locate /tmp/nvidia-mps 
INFO[0000] Using driver version 575.57.08               
...
INFO[0000] Generated CDI spec with version 0.6.2
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-12-0:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-12-0:~# lsmod |grep fake
fake_nvidia_driver     16384  0
root@nvidia-container-toolkit-1-12-0:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
lrwxrwxrwx 1 root root  43 Jun 16 12:39 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  51 Jun 16 12:39 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root 22K Jun 16 12:39 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-12-0:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Tue 2026-06-16 13:08:41 UTC; 23s ago
    Process: 424 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 424 (code=exited, status=0/SUCCESS)
        CPU: 8ms

Jun 16 13:08:41 nvidia-container-toolkit-1-12-0 systemd[1]: Starting Create device nodes for fake nvidia driver...
Jun 16 13:08:41 nvidia-container-toolkit-1-12-0 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jun 16 13:08:41 nvidia-container-toolkit-1-12-0 systemd[1]: Finished Create device nodes for fake nvidia driver.
```

### versions

```shell
root@nvidia-container-toolkit-1-12-0:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.12.0
commit: 62bd015475656ef795cb0d59cc4030a6bd4a9526
root@nvidia-container-toolkit-1-12-0:~# docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.10.2
    Path:     /usr/libexec/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v2.15.1
    Path:     /usr/libexec/docker/cli-plugins/docker-compose
  scan: Docker Scan (Docker Inc.)
    Version:  v0.23.0
    Path:     /usr/libexec/docker/cli-plugins/docker-scan

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 23.0.0
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Using metacopy: false
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: runc io.containerd.runc.v2 nvidia
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 31aa4358a36870b21a992d3ad2bef29e1d693bec
 runc version: v1.1.4-0-g5fd4c4d
 init version: de40ad0
 Security Options:
  apparmor
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 5.15.0-151-generic
 Operating System: Ubuntu 22.04.5 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 1.918GiB
 Name: nvidia-container-toolkit-1-12-0
 ID: 259f5a76-73fb-4f60-9de5-901cb797b1d0
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
root@nvidia-container-toolkit-1-12-0:~# containerd --version
containerd containerd.io 1.6.16 31aa4358a36870b21a992d3ad2bef29e1d693bec
root@nvidia-container-toolkit-1-12-0:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@nvidia-container-toolkit-1-12-0:~# uname -a
Linux nvidia-container-toolkit-1-12-0 5.15.0-151-generic #161-Ubuntu SMP Tue Jul 22 14:25:40 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.12.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.12.0:ctr_v0.9.0
```
