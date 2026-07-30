# containerd v2.3.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.0:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.3.0:v0.2.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.3.0:ctr_v0.2.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v2.3.0
$ ssh dqd-containerd-v2.3.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v2.3.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-2-3-0:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-3-0:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

### versions

```shell
root@containerd-2-3-0:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.3.0 2976f38ccbfcda5ef1364d63d60b0a304e4bf94a
root@containerd-2-3-0:~# runc --version
runc version 1.4.2
commit: v1.4.2-0-gc241c0bb
spec: 1.3.0
go: go1.25.8
libseccomp: 2.6.0
root@containerd-2-3-0:~# cat /etc/os-release
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
root@containerd-2-3-0:~# uname -a
Linux containerd-2-3-0 6.8.0-136-generic #136-Ubuntu SMP PREEMPT_DYNAMIC Wed Jul  1 21:53:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.3.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.3.0:ctr_v0.2.0
```
