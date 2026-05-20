# containerd v1.5.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v1.5.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v1.5.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v1.5.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v1.5.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.5.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v1.5.1
$ ssh dqd-containerd-v1.5.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v1.5.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-1-5-1:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-1-5-1:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-1-5-1:~# containerd --version
containerd github.com/containerd/containerd v1.5.1 12dca9790f4cb6b18a6a7a027ce420145cb98ee7
root@containerd-1-5-1:~# runc --version
runc version 1.0.0-rc94
spec: 1.0.2-dev
go: go1.14.15
libseccomp: 2.5.1
root@containerd-1-5-1:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.6 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.6 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
root@containerd-1-5-1:~# uname -a
Linux containerd-1-5-1 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v1.5.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v1.5.1:ctr_v0.1.0
```
