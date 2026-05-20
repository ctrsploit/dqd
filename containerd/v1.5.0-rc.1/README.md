# containerd v1.5.0-rc.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v1.5.0-rc.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v1.5.0-rc.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v1.5.0-rc.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v1.5.0-rc.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.5.0-rc.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v1.5.0-rc.1
$ ssh dqd-containerd-v1.5.0-rc.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v1.5.0-rc.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-1-5-0-rc-1:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-1-5-0-rc-1:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-1-5-0-rc-1:~# containerd --version
containerd github.com/containerd/containerd v1.5.0-rc.1 f968359ecb3b581e6b61d2c7072f2e4b5347d560
root@containerd-1-5-0-rc-1:~# runc --version
runc version 1.0.0-rc93
spec: 1.0.2-dev
go: go1.14.14
libseccomp: 2.5.1
root@containerd-1-5-0-rc-1:~# cat /etc/os-release
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
root@containerd-1-5-0-rc-1:~# uname -a
Linux containerd-1-5-0-rc-1 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v1.5.0-rc.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v1.5.0-rc.1:ctr_v0.1.0
```
