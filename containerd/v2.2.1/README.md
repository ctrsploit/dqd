# containerd v2.2.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v2.2.1:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/containerd-v2.2.1:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v2.2.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v2.2.1:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v2.2.1_v0.1.0 | - |

## usage

### start up

```shell
$ cd containerd/v2.2.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

### run a container

```shell
root@containerd-2-2-1:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-2-2-1:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

### versions

```shell
$ ./ssh
root@containerd-2-2-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.2.1 dea7da592f5d1d2b7755e3a161be07f43fad8f75
root@containerd-2-2-1:~# runc --version
runc version 1.3.4
commit: v1.3.4-0-gd6d73eb8
spec: 1.2.1
go: go1.24.10
libseccomp: 2.5.6
root@containerd-2-2-1:~# cat /etc/os-release 
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
root@containerd-2-2-1:~# uname -a
Linux containerd-2-2-1 6.8.0-101-generic #101-Ubuntu SMP PREEMPT_DYNAMIC Mon Feb  9 10:15:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v2.2.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v2.2.1:ctr_v0.2.0
```

