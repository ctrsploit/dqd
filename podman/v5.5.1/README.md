# podman v5.5.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v5.5.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v5.5.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:podman-v5.5.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/podman-v5.5.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_podman-v5.5.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v5.5.1
$ ssh dqd-podman-v5.5.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v5.5.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman

```shell
[root@podman-5-5-1 ~]# podman run hello-world
Resolved "hello-world" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull quay.io/podman/hello:latest...
Getting image source signatures
Copying blob sha256:81df7ff16254ed9756e27c8de9ceb02a9568228fccadbf080f41cc5eb5118a44
Copying config sha256:5dd467fce50b56951185da365b5feee75409968cbab5767b9b59e325fb2ecbc0
Writing manifest to image destination
!... Hello Podman World ...!

         .--"--.
       / -     - \
      / (O)   (O) \
   ~~~| -=(,Y,)=- |
    .---. /`  \   |~~
 ~/  o  o \~~~~.----. ~~
  | =(X)= |~  / (O (O) \
   ~~~~~~~  ~| =(Y_)=-  |
  ~~~~    ~~~|   U      |~~

Project:   https://github.com/containers/podman
Website:   https://podman.io
Desktop:   https://podman-desktop.io
Documents: https://docs.podman.io
YouTube:   https://youtube.com/@Podman
X/Twitter: @Podman_io
Mastodon:  @Podman_io@fosstodon.org
```

### versions

```shell
[root@podman-5-5-1 ~]# podman version
Client:       Podman Engine
Version:      5.5.1
API Version:  5.5.1
Go Version:   go1.24.3 (Red Hat 1.24.3-3.el9)
Built:        Tue Jun 10 14:32:25 2025
OS/Arch:      linux/amd64
[root@podman-5-5-1 ~]# crun --version
crun version 1.28
commit: 54f16ffbefcd022bf032af768b5c5ce075c18bfc
rundir: /run/user/0/crun
spec: 1.0.0
+SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +JSON_C
[root@podman-5-5-1 ~]# cat /etc/os-release
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
[root@podman-5-5-1 ~]# uname -a
Linux podman-5-5-1 5.14.0-719.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Jun 29 09:09:38 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=podman/v5.5.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v5.5.1:ctr_v0.1.0
```
