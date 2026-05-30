# docker v29.5.2 with criu

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.5.2-criu:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.5.2-criu:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v29.5.2-criu:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v29.5.2-criu
$ ssh dqd-docker-v29.5.2-criu
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v29.5.2-criu
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with checkpoint/restore

```shell
root@docker-29-5-2-criu:~# printf '{\n  "experimental": true\n}\n' > /etc/docker/daemon.json
root@docker-29-5-2-criu:~# systemctl restart docker
root@docker-29-5-2-criu:~# docker info --format 'Experimental: {{.ExperimentalBuild}}'
Experimental: true
root@docker-29-5-2-criu:~# docker run -d --name test alpine sleep 300
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
6a0ac1617861: Pulling fs layer
6a0ac1617861: Download complete
a63813f19ccb: Download complete
4e0cb4ac63e7: Download complete
6a0ac1617861: Pull complete
Digest: sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11
Status: Downloaded newer image for alpine:latest
5d9eb9415b32c523a481b764806714a782424e950a26685b20c4855533206eee
root@docker-29-5-2-criu:~# docker checkpoint create test checkpoint1
checkpoint1
root@docker-29-5-2-criu:~# docker checkpoint ls test
CHECKPOINT NAME
checkpoint1
root@docker-29-5-2-criu:~# docker start --checkpoint checkpoint1 test
Error response from daemon: bind-mount /proc/0/ns/net -> /var/run/docker/netns/d5adc082d012: no such file or directory
```

### versions

```shell
root@docker-29-5-2-criu:~# docker version
Client: Docker Engine - Community
 Version:           29.5.2
 API version:       1.54
 Go version:        go1.26.3
 Git commit:        79eb04c
 Built:             Wed May 20 14:42:18 2026
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          29.5.2
  API version:      1.54 (minimum version 1.40)
  Go version:       go1.26.3
  Git commit:       568f755
  Built:            Wed May 20 14:42:18 2026
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          v2.2.3
  GitCommit:        77c84241c7cbdd9b4eca2591793e3d4f4317c590
 runc:
  Version:          1.3.5
  GitCommit:        v1.3.5-0-g488fc13e
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@docker-29-5-2-criu:~# criu --version
Version: 4.2
root@docker-29-5-2-criu:~# containerd --version
containerd containerd.io v2.2.3 77c84241c7cbdd9b4eca2591793e3d4f4317c590
root@docker-29-5-2-criu:~# runc --version
runc version 1.3.5
commit: v1.3.5-0-g488fc13e
spec: 1.2.1
go: go1.25.9
libseccomp: 2.5.5
root@docker-29-5-2-criu:~# cat /etc/os-release
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
root@docker-29-5-2-criu:~# uname -a
Linux docker-29-5-2-criu 6.8.0-124-generic #124-Ubuntu SMP PREEMPT_DYNAMIC Tue May 26 13:00:45 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v29.5.2-criu
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.5.2-criu:ctr_v0.1.0
```
