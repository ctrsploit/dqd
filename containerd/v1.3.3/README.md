# containerd v1.3.3

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/containerd-v1.3.3:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/containerd-v1.3.3:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:containerd-v1.3.3_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/containerd-v1.3.3:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_containerd-v1.3.3_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up containerd/v1.3.3
$ ssh dqd-containerd-v1.3.3
```

Fallback without dqd CLI or SSH config:

```shell
$ cd containerd/v1.3.3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### run a container

```shell
root@containerd-1-3-3:~# ctr i pull docker.io/library/hello-world:latest
root@containerd-1-3-3:~# ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
...
```

### versions

```shell
root@containerd-1-3-3:~# containerd --version
containerd github.com/containerd/containerd v1.3.3 d76c121f76a5fc8a462dc64594aea72fe18e1178
root@containerd-1-3-3:~# runc --version
runc version 1.0.0-rc10
spec: 1.0.1-dev
root@containerd-1-3-3:~# cat /etc/os-release
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
root@containerd-1-3-3:~# uname -a
Linux containerd-1-3-3 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=containerd/v1.3.3
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/containerd-v1.3.3:ctr_v0.1.0
```
