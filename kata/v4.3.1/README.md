# kata v4.3.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kata-v4.3.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kata-v4.3.1:v0.1.0 | Kata Containers 4.3.1 (runtime-rs + QEMU) on Docker 29.9.2 / Debian 13.7 |
| ctr | ghcr.io/ctrsploit/kata-v4.3.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kata/v4.3.1
$ ssh dqd-kata-v4.3.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kata/v4.3.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a Kata container

Kata requires `/dev/kvm` and nested virtualization. The compose command starts
the lab VM with `-cpu host`, so the host must expose `vmx`/`svm` to `/dev/kvm`.

```shell
root@kata-4-3-1:~# docker run --runtime kata --rm ubuntu uname -r
6.18.56
```

The printed kernel is the Kata guest kernel, not the lab VM kernel.

### versions

```shell
root@kata-4-3-1:~# docker version
Client: Docker Engine - Community
 Version:           29.9.2
 API version:       1.56
 Go version:        go1.26.10
 Git commit:        a82e528
 Built:             Tue Oct 20 18:45:13 2026
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          29.9.2
  API version:      1.56 (minimum version 1.40)
  Go version:       go1.26.10
  Git commit:       0367cbe
  Built:            Tue Oct 20 18:45:13 2026
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          v2.4.2
  GitCommit:        b7a25261e029d68978bbf290df0a62fc819b3c51
 runc:
  Version:          1.5.2
  GitCommit:        v1.5.2-0-g29dd3dc2
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@kata-4-3-1:~# docker info --format '{{json .Runtimes}}' | jq keys
[
  "io.containerd.runc.v2",
  "kata",
  "runc"
]
root@kata-4-3-1:~# uname -a
Linux kata-4-3-1 6.12.113+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.113-1 (2026-10-15) x86_64 GNU/Linux
root@kata-4-3-1:~# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.7
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```

## build

```shell
make all ENV=kata/v4.3.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/kata-v4.3.1:ctr_v0.1.0
```
