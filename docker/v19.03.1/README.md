# docker v19.03.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v19.03.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-v19.03.1:v0.1.0 | first 19.03.x release with CVE-2019-14271 fixed, base of vul/cve-2019-14271-fix |
| ctr | ghcr.io/ctrsploit/docker-v19.03.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker/v19.03.1
$ ssh dqd-docker-v19.03.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker/v19.03.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@docker-19-03-1:~# docker run -ti busybox:1.31.1 id
uid=0(root) gid=0(root) groups=10(wheel)
```

### versions

```shell
root@docker-19-03-1:~# docker version
Client: Docker Engine - Community
 Version:           19.03.1
 API version:       1.40
 Go version:        go1.12.5
 Git commit:        74b1e89
 Built:             Thu Jul 25 21:21:05 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.1
  API version:       1.40 (minimum version 1.12)
  Go version:        go1.12.5
  Git commit:        74b1e89
  Built:            Thu Jul 25 21:19:41 2019
  OS/Arch:           linux/amd64
  Experimental:      false
 containerd:
  Version:          1.2.6
  GitCommit:        894b81a4b802e4eb2a91d1ce216b8817763c29fb
 runc:
  Version:          1.0.0-rc8
  GitCommit:        425e105d5a03fabd737a126ad93d62a9eeede87f
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
root@docker-19-03-1:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.6 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.6 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
root@docker-19-03-1:~# uname -a
Linux docker-19-03-1 4.15.0-213-generic #224-Ubuntu SMP Mon Jun 19 13:30:12 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker/v19.03.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v19.03.1:ctr_v0.1.0
```
