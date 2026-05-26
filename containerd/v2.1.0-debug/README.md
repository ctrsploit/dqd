# containerd v2.1.0-debug

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.0-debug:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.1.0-debug:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.1.0-debug_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.1.0-debug:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.1.0-debug_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.1.0-debug
$ ssh dqd-containerd-v2.1.0-debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.1.0-debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### debug mode

debug scripts for each binary:

| binary | host port |
|--------|-----------|
| runc | 21013 |
| ctr | 21015 |
| containerd | 21016 |
| containerd-stress | 21017 |
| containerd-shim-runc-v2 | 21018 |

Use `debug.sh runc`, `debug.sh ctr`, etc. to start debugging.

### attach to init

```shell
root@containerd-2-1-0-debug:~# attach.sh <pid>
```

### versions

```shell
root@containerd-2-1-0-debug:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.0 061792f0ecf3684fb30a3a0eb006799b8c6638a7
root@containerd-2-1-0-debug:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@containerd-2-1-0-debug:~# cat /etc/os-release
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
root@containerd-2-1-0-debug:~# uname -a
Linux containerd-2-1-0-debug 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.1.0-debug
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.1.0-debug:ctr_v0.1.0
```
