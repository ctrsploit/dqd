# podman v5.5.1 debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v5.5.1-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v5.5.1-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:podman-v5.5.1-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/podman-v5.5.1-debug:ctr_v0.1.0 | add podman debug binary and dlv |
| ctr | ssst0n3/docker_archive:ctr_podman-v5.5.1-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v5.5.1-debug
$ ssh dqd-podman-v5.5.1-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v5.5.1-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug podman with dlv

| Component | Host port |
| --------- | --------- |
| podman | 55102 |

```shell
root@podman-5-5-1-debug:~# ln -sf /usr/local/bin/debug.sh /usr/bin/podman
root@podman-5-5-1-debug:~# timeout 5 podman run -u nobody -ti --cap-add CAP_DAC_OVERRIDE ubuntu bash
API server listening at: [::]:2341
2026-07-06T07:01:14Z warn layer=rpc Listening for remote connections (connections are not authenticated nor encrypted)
```

### versions

```shell
root@podman-5-5-1-debug:~# /root/bin/podman.real version
Client:       Podman Engine
Version:      5.5.1
API Version:  5.5.1
Go Version:   go1.24.3 (Red Hat 1.24.3-3.el9)
Built:        Tue Jun 10 14:32:25 2025
OS/Arch:      linux/amd64
root@podman-5-5-1-debug:~# /root/bin/podman.debug version
Client:       Podman Engine
Version:      5.5.1
API Version:  5.5.1
Go Version:   go1.23.9
Built:        Thu Jan  1 00:00:00 1970
OS/Arch:      linux/amd64
root@podman-5-5-1-debug:~# dlv version
Delve Debugger
Version: 1.24.2
Build: $Id: 7e679e5860c17d90514f9c440e055355de831ce2 $
root@podman-5-5-1-debug:~# crun --version
crun version 1.28
commit: 54f16ffbefcd022bf032af768b5c5ce075c18bfc
rundir: /run/user/0/crun
spec: 1.0.0
+SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +JSON_C
root@podman-5-5-1-debug:~# cat /etc/os-release
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
root@podman-5-5-1-debug:~# uname -a
Linux podman-5-5-1-debug 5.14.0-719.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Jun 29 09:09:38 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=podman/v5.5.1-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v5.5.1-debug:ctr_v0.1.0
```
