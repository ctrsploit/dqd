# containerd v2.2.3

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.2.3:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.2.3:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.2.3:ctr_v0.1.0 | - |

## usage

### start up

```shell
$ cd containerd/v2.2.3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

### run a container

```shell
root@containerd-2-2-3:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-2-3:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

### versions

```shell
$ ./ssh
root@containerd-2-2-3:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.2.3 77c84241c7cbdd9b4eca2591793e3d4f4317c590
root@containerd-2-2-3:~# runc --version
runc version 1.3.5
commit: v1.3.5-0-g488fc13e
spec: 1.2.1
go: go1.25.8
libseccomp: 2.6.0
root@containerd-2-2-3:~# cat /etc/os-release
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
root@containerd-2-2-3:~# uname -a
Linux containerd-2-2-3 6.8.0-110-generic #110-Ubuntu SMP PREEMPT_DYNAMIC Thu Mar 19 15:09:20 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.2.3
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.2.3:ctr_v0.1.0
```
