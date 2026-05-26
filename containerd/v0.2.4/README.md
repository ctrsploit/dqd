# containerd v0.2.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v0.2.4:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v0.2.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v0.2.4_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v0.2.4:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v0.2.4_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v0.2.4
$ ssh dqd-containerd-v0.2.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v0.2.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### versions

```shell
root@containerd-0-2-4:~# containerd --version
containerd version 0.2.4 commit: 71861281661331fbc81936be81f05d8db71fc1ca
root@containerd-0-2-4:~# runc --version
runc version 1.0.0-rc1
commit: 04f275d4601ca7e5ff9460cec7f65e8dd15443ec
spec: 1.0.0-rc1
root@containerd-0-2-4:~# cat /etc/os-release
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
root@containerd-0-2-4:~# uname -a
Linux containerd-0-2-4 4.4.0-210-generic #242-Ubuntu SMP Fri Apr 16 09:57:56 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v0.2.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v0.2.4:ctr_v0.1.0
```
