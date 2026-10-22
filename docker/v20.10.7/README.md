# docker v20.10.7

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v20.10.7:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v20.10.7:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v20.10.7:ctr_v0.1.0 | bundles runc v1.0.0-rc95 (fixes CVE-2021-30465) |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v20.10.7
$ ssh dqd-docker-v20.10.7
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v20.10.7
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-20-10-7:~# docker run --rm busybox echo it-works
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
37bb94b0940b: Pulling fs layer
37bb94b0940b: Download complete
37bb94b0940b: Pull complete
Digest: sha256:fd7dc98638c8e305f4dc34e979f1c0fdfdcaeb0fbf8fcff77ae834b6da3d7e6e
Status: Downloaded newer image for busybox:latest
it-works
```

### versions

```shell
root@docker-20-10-7:~# docker version
Client: Docker Engine - Community
 Version:           20.10.7
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        f0df350
 Built:             Wed Jun  2 11:56:38 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.7
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       b0f5bc3
  Built:            Wed Jun  2 11:54:50 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.6
  GitCommit:        d71fcd7d8303cbf684402823e425e9dd2e99285d
 runc:
  Version:          1.0.0-rc95
  GitCommit:        b9ee9c6314599f1b4a7f497e1f1f856fe433d3b7
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@docker-20-10-7:~# runc --version
runc version 1.0.0-rc95
commit: b9ee9c6314599f1b4a7f497e1f1f856fe433d3b7
spec: 1.0.2-dev
go: go1.13.15
libseccomp: 2.5.1
root@docker-20-10-7:~# cat /etc/os-release
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
root@docker-20-10-7:~# uname -a
Linux docker-20-10-7 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v20.10.7
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v20.10.7:ctr_v0.1.0
```
