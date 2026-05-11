# docker v20.10.12

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v20.10.12:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/docker-v20.10.12:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v20.10.12_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v20.10.12:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v20.10.12_v0.1.0 | - |

## usage

```shell
$ cd docker/v20.10.12
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@docker-20-10-12:~# docker version
Client: Docker Engine - Community
 Version:           20.10.12
 API version:       1.41
 Go version:        go1.16.12
 Git commit:        e91ed57
 Built:             Mon Dec 13 11:45:33 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.12
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.12
  Git commit:       459d0df
  Built:            Mon Dec 13 11:43:42 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.12
  GitCommit:        7b11cfaabd73bb80907dd23182b9347b4245eb5d
 runc:
  Version:          1.0.2
  GitCommit:        v1.0.2-0-g52b36a2
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@docker-20-10-12:~# containerd --version
containerd containerd.io 1.4.12 7b11cfaabd73bb80907dd23182b9347b4245eb5d
root@docker-20-10-12:~# runc --version
runc version 1.0.2
commit: v1.0.2-0-g52b36a2
spec: 1.0.2-dev
go: go1.16.10
libseccomp: 2.5.1
root@docker-20-10-12:~# cat /etc/os-release
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
```

## build

```shell
make all ENV=docker/v20.10.12
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v20.10.12:ctr_v0.2.0
```
