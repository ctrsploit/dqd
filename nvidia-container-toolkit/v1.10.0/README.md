# nvidia-container-toolkit v1.10.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.10.0:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.10.0:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.10.0_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.10.0:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.10.0_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.10.0
$ ssh dqd-nvidia-container-toolkit-v1.10.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.10.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-10-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-10-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<cid>/config.json | jq .hooks
<!-- VERIFY -->
```

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/1.10.0/install-guide.html

### CDI mode

nvidia-container-toolkit v1.10.0 does not support CDI mode yet.

### CSV mode

```shell
root@nvidia-container-toolkit-1-10-0:~# sed -i s/auto/csv/g /etc/nvidia-container-runtime/config.toml
root@nvidia-container-toolkit-1-10-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-10-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<cid>/config.json | jq .hooks
<!-- VERIFY -->
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-10-0:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-10-0:~# lsmod |grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-10-0:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
lrwxrwxrwx 1 root root  43 Jun 15 10:52 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  51 Jun 15 10:52 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root 22K Jun 15 10:52 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-10-0:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Tue 2026-06-16 03:23:36 UTC; 15min ago
    Process: 420 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 420 (code=exited, status=0/SUCCESS)
        CPU: 9ms

Jun 16 03:23:36 nvidia-container-toolkit-1-10-0 systemd[1]: Starting Create device nodes for fake nvidia driver...
Jun 16 03:23:36 nvidia-container-toolkit-1-10-0 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jun 16 03:23:36 nvidia-container-toolkit-1-10-0 systemd[1]: Finished Create device nodes for fake nvidia driver.
```

### versions

```shell
root@nvidia-container-toolkit-1-10-0:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.10.0
commit: 7cfd3bd
root@nvidia-container-toolkit-1-10-0:~# docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Docker Buildx (Docker Inc., v0.8.2-docker)
  scan: Docker Scan (Docker Inc., v0.23.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 20.10.17
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
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
 Runtimes: io.containerd.runtime.v1.linux nvidia runc io.containerd.runc.v2
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 10c12954828e7c7c9b6e0ea9b0c02b01407d3ae1
 runc version: v1.1.2-0-ga916309
 init version: de40ad0
 Security Options:
  apparmor
  seccomp
   Profile: default
  cgroupns
 Kernel Version: 5.15.0-181-generic
 Operating System: Ubuntu 22.04.5 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 1.918GiB
 Name: nvidia-container-toolkit-1-10-0
 ID: 6TDC:AABS:NWDV:U5PV:NA5S:QM4X:6A3H:6R4J:KRNZ:RXLT:BP5A:YGKX
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
root@nvidia-container-toolkit-1-10-0:~# containerd --version
containerd containerd.io 1.6.6 10c12954828e7c7c9b6e0ea9b0c02b01407d3ae1
root@nvidia-container-toolkit-1-10-0:~# cat /etc/os-release
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
root@nvidia-container-toolkit-1-10-0:~# uname -a
Linux nvidia-container-toolkit-1-10-0 5.15.0-181-generic #191-Ubuntu SMP Fri May 22 19:09:02 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.10.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.10.0:ctr_v0.9.0
```
