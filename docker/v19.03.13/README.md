# docker v19.03.13

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v19.03.13:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v19.03.13:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-v19.03.13_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v19.03.13:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-v19.03.13_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v19.03.13
$ ssh dqd-docker-v19.03.13
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v19.03.13
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-19-03-13:~# docker run -ti ubuntu:20.04 id
uid=0(root) gid=0(root) groups=0(root)
```

### versions

```shell
root@docker-19-03-13:~# docker version
Client: Docker Engine - Community
 Version:           19.03.13
 API version:       1.40
 Go version:        go1.13.15
 Git commit:        4484c46d9d
 Built:             Wed Sep 16 17:02:52 2020
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.13
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       4484c46d9d
  Built:            Wed Sep 16 17:01:20 2020
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.3.7
  GitCommit:        8fba4e9a7d01810a393d5d25a3621dc101981175
 runc:
  Version:          1.0.0-rc10
  GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
root@docker-19-03-13:~# cat /etc/os-release
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
root@docker-19-03-13:~# uname -a
Linux docker-19-03-13 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v19.03.13
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v19.03.13:ctr_v0.1.0
```
