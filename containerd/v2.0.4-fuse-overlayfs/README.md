# containerd v2.0.4 with fuse-overlayfs

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.4-fuse-overlayfs:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.4-fuse-overlayfs:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.0.4-fuse-overlayfs_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:containerd-v2.0.4-fuse-overlayfs_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.0.4-fuse-overlayfs:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.4-fuse-overlayfs_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.4-fuse-overlayfs_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.0.4-fuse-overlayfs
$ ssh dqd-containerd-v2.0.4-fuse-overlayfs
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.0.4-fuse-overlayfs
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-0-4-fuse-overlayfs:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-0-4-fuse-overlayfs:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### verify fuse-overlayfs

```shell
root@containerd-2-0-4-fuse-overlayfs:~# systemctl status containerd-fuse-overlayfs
● containerd-fuse-overlayfs.service - containerd fuse-overlayfs snapshotter
     Loaded: loaded (/etc/systemd/system/containerd-fuse-overlayfs.service; enabled; preset: enabled)
     Active: active (running) since Fri 2026-05-22 02:54:55 UTC; 51s ago
   Main PID: 282 (containerd-fuse)
      Tasks: 5 (limit: 2327)
     Memory: 13.9M (peak: 14.3M)
        CPU: 553ms
     CGroup: /system.slice/containerd-fuse-overlayfs.service
             └─282 /usr/local/bin/containerd-fuse-overlayfs-grpc /run/containerd-fuse-overlayfs.sock /var/lib/containerd-fuse-overlayfs

May 22 02:54:53 containerd-2-0-4-fuse-overlayfs systemd[1]: Starting containerd-fuse-overlayfs.service - containerd fuse-overlayfs snapshotter...
May 22 02:54:54 containerd-2-0-4-fuse-overlayfs containerd-fuse-overlayfs-grpc[282]: time="2026-05-22T02:54:54Z" level=info msg="containerd-fuse-overlayfs-grpc Version=\"v2.1.2\" Revision=\"d6076ad2d8205d581a2e63227cd332aeeb656ef7\""
May 22 02:54:55 containerd-2-0-4-fuse-overlayfs systemd[1]: Started containerd-fuse-overlayfs.service - containerd fuse-overlayfs snapshotter.
root@containerd-2-0-4-fuse-overlayfs:~# systemctl status containerd
● containerd.service - containerd container runtime
     Loaded: loaded (/usr/local/lib/systemd/system/containerd.service; enabled; preset: enabled)
     Active: active (running) since Fri 2026-05-22 02:54:57 UTC; 48s ago
       Docs: https://containerd.io
    Process: 292 ExecStartPre=/sbin/modprobe overlay (code=exited, status=0/SUCCESS)
   Main PID: 297 (containerd)
      Tasks: 8
     Memory: 73.1M (peak: 76.3M)
        CPU: 2.177s
     CGroup: /system.slice/containerd.service
             └─297 /usr/local/bin/containerd

May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.628628160Z" level=info msg="Start cni network conf syncer for default"
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.628965750Z" level=info msg="Start streaming server"
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.635416450Z" level=info msg=serving... address=/run/containerd/containerd.sock.ttrpc
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.639941630Z" level=info msg=serving... address=/run/containerd/containerd.sock
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.653478120Z" level=info msg="Registered namespace \"k8s.io\" with NRI"
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.657312310Z" level=info msg="runtime interface starting up..."
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.657657880Z" level=info msg="starting plugins..."
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.658105370Z" level=info msg="Synchronizing NRI (plugin) with current runtime state"
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs containerd[297]: time="2026-05-22T02:54:57.684944360Z" level=info msg="containerd successfully booted in 1.512359s"
May 22 02:54:57 containerd-2-0-4-fuse-overlayfs systemd[1]: Started containerd.service - containerd container runtime.
```

### versions

```shell
root@containerd-2-0-4-fuse-overlayfs:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.4 1a43cb6a1035441f9aca8f5666a9b3ef9e70ab20
root@containerd-2-0-4-fuse-overlayfs:~# runc --version
runc version 1.2.5
commit: v1.2.5-0-g59923ef1
spec: 1.2.0
go: go1.22.12
libseccomp: 2.5.5
root@containerd-2-0-4-fuse-overlayfs:~# cat /etc/os-release
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
root@containerd-2-0-4-fuse-overlayfs:~# uname -a
Linux containerd-2-0-4-fuse-overlayfs 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.0.4-fuse-overlayfs
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.0.4-fuse-overlayfs:ctr_v0.1.0
```
