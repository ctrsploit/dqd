# podman v6.1.4 with runc v1.5.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:latest | points to `v0.1.1` |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:v0.1.1 | v0.1.0 with the runtime set through `/etc/containers/containers.conf.d/10-runtime.conf`: Fedora's vendor drop-in `00-vendor.conf` sets `[engine] runtime = "crun"` and is loaded after `/etc/containers/containers.conf`, so the bare config file was silently overridden (engine still resolved crun) |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:v0.1.0 | superseded: `[engine] runtime = "runc"` in `/etc/containers/containers.conf` had no effect |
| ctr | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:ctr_v0.1.1 | - |
| ctr | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v6.1.4-runc-v1.5.2
$ ssh dqd-podman-v6.1.4-runc-v1.5.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v6.1.4-runc-v1.5.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman (runc)

```shell
[root@podman-6-1-4-runc-v1-5-2 ~]# podman info --format '{{.Host.OCIRuntime.Name}}'
runc
[root@podman-6-1-4-runc-v1-5-2 ~]# podman run hello-world
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
[root@podman-6-1-4-runc-v1-5-2 ~]# podman version
Client:       Podman Engine
Version:      6.1.4
API Version:  6.1.4
Go Version:   go1.26.10
Built:        Thu Nov  5 10:58:41 2026
OS/Arch:      linux/amd64
[root@podman-6-1-4-runc-v1-5-2 ~]# runc --version
runc version 1.5.2
commit: v1.5.2-0-g29dd3dc
spec: 1.3.0
go: go1.26.8
libseccomp: 2.6.1
libpathrs: 0.2.6
[root@podman-6-1-4-runc-v1-5-2 ~]# cat /etc/os-release
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
[root@podman-6-1-4-runc-v1-5-2 ~]# uname -a
Linux podman-6-1-4-runc-v1-5-2 7.2.15-300.fc45.x86_64 #1 SMP PREEMPT_DYNAMIC Sun Nov  1 16:11:16 UTC 2026 x86_64 GNU/Linux
```

## build

```shell
make all ENV=podman/v6.1.4-runc-v1.5.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:ctr_v0.1.0
```
