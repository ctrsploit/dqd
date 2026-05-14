# containerd v2.2.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.2.0:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.2.0:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.2.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.2.0:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.2.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.2.0
$ ssh dqd-containerd-v2.2.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.2.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-2-0:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-2-0:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

### versions

```shell
root@containerd-2-2-0:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.2.0 1c4457e00facac03ce1d75f7b6777a7a851e5c41
root@containerd-2-2-0:~# runc --version
runc version 1.3.3
commit: v1.3.3-0-gd842d771
spec: 1.2.1
go: go1.23.12
libseccomp: 2.5.6
root@containerd-2-2-0:~# cat /etc/os-release
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
root@containerd-2-2-0:~# uname -a
Linux containerd-2-2-0 6.8.0-111-generic #111-Ubuntu SMP PREEMPT_DYNAMIC Sat Apr 11 23:16:02 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.2.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.2.0:ctr_v0.2.0
```
