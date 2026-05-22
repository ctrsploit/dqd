# containerd v2.0.5

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.5:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.0.5:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.0.5_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.0.5:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.0.5_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.0.5
$ ssh dqd-containerd-v2.0.5
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.0.5
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-0-5:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-0-5:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-2-0-5:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.5 fb4c30d4ede3531652d86197bf3fc9515e5276d9
root@containerd-2-0-5:~# runc --version
runc version 1.2.6
commit: v1.2.6-0-ge89a2992
spec: 1.2.0
go: go1.23.7
libseccomp: 2.5.5
root@containerd-2-0-5:~# cat /etc/os-release
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
root@containerd-2-0-5:~# uname -a
Linux containerd-2-0-5 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.0.5
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.0.5:ctr_v0.1.0
```
