# docker v20.10.6

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v20.10.6:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v20.10.6:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v20.10.6:ctr_v0.1.0 | bundles runc v1.0.0-rc93 (target of CVE-2021-30465) |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v20.10.6
$ ssh dqd-docker-v20.10.6
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v20.10.6
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-20-10-6:~# docker run --rm busybox echo it-works
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
root@docker-20-10-6:~# docker version
Client: Docker Engine - Community
 Version:           20.10.6
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        370c289
 Built:             Fri Apr  9 22:47:17 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.6
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       8728dd2
  Built:            Fri Apr  9 22:45:28 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.4
  GitCommit:        05f951a3781f4f2c1911b05e61c160e9c30eaa8e
 runc:
  Version:          1.0.0-rc93
  GitCommit:        12644e614e25b05da6fd08a38ffa0cfe1903fdec
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@docker-20-10-6:~# runc --version
runc version 1.0.0-rc93
commit: 12644e614e25b05da6fd08a38ffa0cfe1903fdec
spec: 1.0.2-dev
go: go1.13.15
libseccomp: 2.5.1
root@docker-20-10-6:~# cat /etc/os-release
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
root@docker-20-10-6:~# uname -a
Linux docker-20-10-6 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v20.10.6
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v20.10.6:ctr_v0.1.0
```
