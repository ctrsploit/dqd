# containerd v2.1.1-debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.1-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.1-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.1.1-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.1.1-debug:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.1.1-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.1.1-debug
$ ssh dqd-containerd-v2.1.1-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.1.1-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### debug mode

debug scripts for each binary:

| binary | host port |
|--------|-----------|
| runc | 21103 |
| ctr | 21105 |
| containerd | 21106 |
| containerd-stress | 21107 |
| containerd-shim-runc-v2 | 21108 |

### versions

```shell
root@containerd-2-1-1-debug:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.1 cb1076646aa3740577fafbf3d914198b7fe8e3f7
root@containerd-2-1-1-debug:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@containerd-2-1-1-debug:~# cat /etc/os-release
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
root@containerd-2-1-1-debug:~# uname -a
Linux containerd-2-1-1-debug 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.1.1-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.1.1-debug:ctr_v0.1.0
```
