# nvidia-container-toolkit v1.13.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.13.0:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.13.0:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.13.0_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.13.0:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.13.0_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.13.0
$ ssh dqd-nvidia-container-toolkit-v1.13.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.13.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

https://web.archive.org/web/20230627162323/https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-13-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
5cc7b106e98ed416fddda7a65bce93843565d45576df740366d3531eea640762
root@nvidia-container-toolkit-1-13-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/5cc7b106e98ed416fddda7a65bce93843565d45576df740366d3531eea640762/config.json | jq .hooks
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
      "path": "/proc/301/exe",
      "args": [
        "libnetwork-setkey",
        "-exec-root=/var/run/docker",
        "5cc7b106e98ed416fddda7a65bce93843565d45576df740366d3531eea640762",
        "0fe511f61fec"
      ]
    }
  ]
}
```

### CDI mode

```shell
root@nvidia-container-toolkit-1-13-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
INFO[0000] Auto-detected mode as "nvml"                 
INFO[0000] Selecting /dev/nvidia0 as /dev/nvidia0       
...
INFO[0000] Selecting /dev/nvidia3 as /dev/nvidia3       
INFO[0000] Using driver version 575.57.08               
...
INFO[0000] Generated CDI spec with version 0.5.0
root@nvidia-container-toolkit-1-13-0:~# sed -i s/auto/cdi/g /etc/nvidia-container-runtime/config.toml
root@nvidia-container-toolkit-1-13-0:~# docker run -tid --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=nvidia.com/gpu=all ubuntu
e0f8bb9fcabc6e1338d9764ba855da957b48c6a64bbec91832f65df922b3eba4
root@nvidia-container-toolkit-1-13-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/e0f8bb9fcabc6e1338d9764ba855da957b48c6a64bbec91832f65df922b3eba4/config.json | jq .hooks
{
  "prestart": [
    {
      "path": "/proc/301/exe",
      "args": [
        "libnetwork-setkey",
        "-exec-root=/var/run/docker",
        "e0f8bb9fcabc6e1338d9764ba855da957b48c6a64bbec91832f65df922b3eba4",
        "0fe511f61fec"
      ]
    }
  ],
  "createContainer": [
    {
      "path": "/usr/bin/nvidia-ctk",
      "args": [
        "nvidia-ctk",
        "hook",
        "update-ldcache",
        "--folder",
        "/lib/x86_64-linux-gnu"
      ]
    }
  ]
}
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-13-0:~# nvidia-container-cli info
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
root@nvidia-container-toolkit-1-13-0:~# lsmod |grep fake
fake_nvidia_driver     16384  0
root@nvidia-container-toolkit-1-13-0:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
lrwxrwxrwx 1 root root  43 Jun 17 02:35 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
lrwxrwxrwx 1 root root  51 Jun 17 02:35 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 -> /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
-rwxr-xr-x 1 root root 22K Jun 17 02:35 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.575.57.08
root@nvidia-container-toolkit-1-13-0:~# systemctl status fake-nvidia-device
○ fake-nvidia-device.service - Create device nodes for fake nvidia driver
     Loaded: loaded (/etc/systemd/system/fake-nvidia-device.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Wed 2026-06-17 03:06:38 UTC; 20s ago
    Process: 420 ExecStart=/usr/local/bin/fake-nvidia-device.sh (code=exited, status=0/SUCCESS)
   Main PID: 420 (code=exited, status=0/SUCCESS)
        CPU: 7ms

Jun 17 03:06:38 nvidia-container-toolkit-1-13-0 systemd[1]: Starting Create device nodes for fake nvidia driver...
Jun 17 03:06:38 nvidia-container-toolkit-1-13-0 systemd[1]: fake-nvidia-device.service: Deactivated successfully.
Jun 17 03:06:38 nvidia-container-toolkit-1-13-0 systemd[1]: Finished Create device nodes for fake nvidia driver.
```

### versions

```shell
root@nvidia-container-toolkit-1-13-0:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.13.0
commit: b7079454b5b8fed1390ce78ca5a3343748f62657
root@nvidia-container-toolkit-1-13-0:~# docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.10.4
    Path:     /usr/libexec/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v2.17.2
    Path:     /usr/libexec/docker/cli-plugins/docker-compose

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 23.0.3
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
 Runtimes: io.containerd.runc.v2 nvidia runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 1e1ea6e986c6c86565bc33d52e34b81b3e2bc71f
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
 Name: nvidia-container-toolkit-1-13-0
 ID: 60d5a793-f482-4e59-8beb-b421dd1ae2a0
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
root@nvidia-container-toolkit-1-13-0:~# containerd --version
containerd containerd.io 1.6.19 1e1ea6e986c6c86565bc33d52e34b81b3e2bc71f
root@nvidia-container-toolkit-1-13-0:~# cat /etc/os-release
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
root@nvidia-container-toolkit-1-13-0:~# uname -a
Linux nvidia-container-toolkit-1-13-0 5.15.0-151-generic #161-Ubuntu SMP Tue Jul 22 14:25:40 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.13.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.13.0:ctr_v0.9.0
```
