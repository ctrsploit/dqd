# docker v29.4.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-v29.4.1:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/docker-v29.4.1:v0.2.0 | dynamic linked runc |
| dqd | ghcr.io/ctrsploit/docker-v29.4.1:v0.1.0 | static linked runc |
| ctr | ghcr.io/ctrsploit/docker-v29.4.1:ctr_v0.2.0 | - |
| ctr | ghcr.io/ctrsploit/docker-v29.4.1:ctr_v0.1.0 | - |

## usage

```shell
$ cd docker/v29.4.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

```shell
$ ./ssh
root@docker-29-4-1:~# docker run -ti hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
e6590344b1a5: Pull complete 
Digest: sha256:ec153840d1e635ac434fab5e377081f17e0e15afab27beb3f726c3265039cfff
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
```

```shell
$ ./ssh
root@docker-29-4-1:~# docker version
Client: Docker Engine - Community
 Version:           29.4.1
 API version:       1.54
 Go version:        go1.26.2
 Git commit:        055a478
 Built:             Mon Apr 20 16:32:37 2026
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          29.4.1
  API version:      1.54 (minimum version 1.40)
  Go version:       go1.26.2
  Git commit:       6c91b92
  Built:            Mon Apr 20 16:32:37 2026
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
root@docker-29-4-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.2.3 77c84241c7cbdd9b4eca2591793e3d4f4317c590
root@docker-29-4-1:~# cat /etc/os-release
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
root@docker-29-4-1:~# uname -a
Linux docker-29-4-1 6.8.0-110-generic #110-Ubuntu SMP PREEMPT_DYNAMIC Thu Mar 19 15:09:20 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all DIR=docker/v29.4.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-v29.4.1:ctr_v0.2.0
```
