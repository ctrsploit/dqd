# podman v6.1.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4:v0.1.0 | podman 6.1.4 (source build) on `ghcr.io/ctrsploit/fedora-45` (podman 6.1.x's native distro; 6.1-era crun/conmon/netavark from the f45 release repos) |
| ctr | ghcr.io/ctrsploit/podman-v6.1.4:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v6.1.4
$ ssh dqd-podman-v6.1.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v6.1.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman

```shell
[root@podman-6-1-4 ~]# podman run hello-world
Resolved "hello-world" as an alias (/usr/share/containers/registries.conf.d/000-shortnames.conf)
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
[root@podman-6-1-4 ~]# podman version
Client:       Podman Engine
Version:      6.1.4
API Version:  6.1.4
Go Version:   go1.26.10
Built:        Thu Nov  5 10:58:41 2026
OS/Arch:      linux/amd64
[root@podman-6-1-4 ~]# crun --version
crun version 1.30.1
commit: 079ff6a7a16d029460af882f9ea44674e6a510b6
rundir: /run/user/0/crun
spec: 1.0.0
+SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +LIBKRUN +WASM:wasmedge +JSON_C
[root@podman-6-1-4 ~]# cat /etc/os-release
NAME="Fedora Linux"
VERSION="45 (Container Image)"
RELEASE_TYPE=stable
ID=fedora
VERSION_ID=45
VERSION_CODENAME=""
PRETTY_NAME="Fedora Linux 45 (Container Image)"
ANSI_COLOR="0;38;2;60;110;180"
LOGO=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:45"
DEFAULT_HOSTNAME="fedora"
HOME_URL="https://fedoraproject.org/"
DOCUMENTATION_URL="https://docs.fedoraproject.org/en-US/fedora/f45/"
SUPPORT_URL="https://ask.fedoraproject.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_BUGZILLA_PRODUCT="Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=45
REDHAT_SUPPORT_PRODUCT="Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=45
SUPPORT_END=2027-12-08
VARIANT="Container Image"
VARIANT_ID=container
[root@podman-6-1-4 ~]# uname -a
Linux podman-6-1-4 7.2.15-300.fc45.x86_64 #1 SMP PREEMPT_DYNAMIC Sun Nov  1 16:11:16 UTC 2026 x86_64 GNU/Linux
```

## build

```shell
make all ENV=podman/v6.1.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v6.1.4:ctr_v0.1.0
```
