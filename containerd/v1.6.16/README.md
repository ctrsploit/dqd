# containerd v1.6.16

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v1.6.16:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v1.6.16:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v1.6.16_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v1.6.16:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.6.16_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v1.6.16
$ ssh dqd-containerd-v1.6.16
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v1.6.16
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-1-6-16:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-1-6-16:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-1-6-16:~# containerd --version
containerd github.com/containerd/containerd v1.6.16 31aa4358a36870b21a992d3ad2bef29e1d693bec
root@containerd-1-6-16:~# runc --version
runc version 1.1.4
commit: v1.1.4-0-g5fd4c4d1
spec: 1.0.2-dev
go: go1.17.10
libseccomp: 2.5.4
root@containerd-1-6-16:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@containerd-1-6-16:~# uname -a
Linux containerd-1-6-16 5.15.0-179-generic #189-Ubuntu SMP Tue May 5 18:20:56 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v1.6.16
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v1.6.16:ctr_v0.1.0
```
