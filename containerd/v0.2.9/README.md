# containerd v0.2.9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v0.2.9:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v0.2.9:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v0.2.9_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v0.2.9:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v0.2.9_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v0.2.9
$ ssh dqd-containerd-v0.2.9
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v0.2.9
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### versions

```shell
root@containerd-0-2-9:~# containerd --version
containerd version 0.2.3 commit: cfb82a876ecc11b5ca0977d1733adbe58599088a
root@containerd-0-2-9:~# runc --version
runc version 1.0.0-rc3
commit: -dirty
spec: 1.0.0-rc5
root@containerd-0-2-9:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.7 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.7 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
root@containerd-0-2-9:~# uname -a
Linux containerd-0-2-9 4.4.0-210-generic #242-Ubuntu SMP Fri Apr 16 09:57:56 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v0.2.9
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v0.2.9:ctr_v0.1.0
```
