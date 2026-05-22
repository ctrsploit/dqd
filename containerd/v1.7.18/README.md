# containerd v1.7.18

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v1.7.18:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v1.7.18:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v1.7.18_v0.2.0 | bump the base image |
| dqd | ssst0n3/docker_archive:containerd-v1.7.18_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v1.7.18:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.7.18_v0.2.0 | bump the base image |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.7.18_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v1.7.18
$ ssh dqd-containerd-v1.7.18
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v1.7.18
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-1-7-18:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-1-7-18:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-1-7-18:~# containerd --version
containerd github.com/containerd/containerd v1.7.18 ae71819c4f5e67bb4d5ae76a6b735f29cc25774e
root@containerd-1-7-18:~# runc --version
runc version 1.1.12
commit: v1.1.12-0-g51d5e946
spec: 1.0.2-dev
go: go1.20.13
libseccomp: 2.5.4
root@containerd-1-7-18:~# cat /etc/os-release
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
root@containerd-1-7-18:~# uname -a
Linux containerd-1-7-18 5.15.0-179-generic #189-Ubuntu SMP Tue May 5 18:20:56 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v1.7.18
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v1.7.18:ctr_v0.1.0
```
