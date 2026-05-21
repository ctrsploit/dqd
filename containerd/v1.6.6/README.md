# containerd v1.6.6

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v1.6.6:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v1.6.6:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v1.6.6_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v1.6.6:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.6.6_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v1.6.6
$ ssh dqd-containerd-v1.6.6
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v1.6.6
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-1-6-6:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-1-6-6:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-1-6-6:~# containerd --version
containerd github.com/containerd/containerd v1.6.6 10c12954828e7c7c9b6e0ea9b0c02b01407d3ae1
root@containerd-1-6-6:~# runc --version
runc version 1.1.2
commit: v1.1.2-0-ga916309f
spec: 1.0.2-dev
go: go1.17.10
libseccomp: 2.5.3
root@containerd-1-6-6:~# cat /etc/os-release
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
root@containerd-1-6-6:~# uname -a
Linux containerd-1-6-6 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v1.6.6
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v1.6.6:ctr_v0.1.0
```
