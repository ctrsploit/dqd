# buildx v0.38.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildx-v0.38.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildx-v0.38.1:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildx-v0.38.1:ctr_v0.1.0 | - |

buildx CLI plugin v0.38.1 on top of Docker Engine 29.7.2 (base: `docker-v29.7.2:ctr_v0.1.0`, Ubuntu 24.04).
Docker runs inside the VM; `docker build` goes through BuildKit. No host Docker socket is used.

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildx/v0.38.1
$ ssh dqd-buildx-v0.38.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildx/v0.38.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with docker build

```shell
root@buildx-0-38-1:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildx-0-38-1:~# docker build -t buildx-demo .
#0 building with "default" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile:
#1 transferring dockerfile: 60B done
#1 DONE 0.2s

#2 [internal] load metadata for docker.io/library/ubuntu:latest
#2 DONE 3.9s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.1s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c
#4 resolve docker.io/library/ubuntu:latest@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c 0.1s done
#4 DONE 0.3s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c
#4 sha256:f3f25b84a7d74315d94ee4108231f8f5e0cd2a44725a7204d5dd6ce91c151697 0B / 392B 0.2s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 0B / 42.14MB 0.2s
#4 sha256:f3f25b84a7d74315d94ee4108231f8f5e0cd2a44725a7204d5dd6ce91c151697 392B / 392B 0.5s done
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 5.24MB / 42.14MB 1.2s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 8.39MB / 42.14MB 1.4s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 11.53MB / 42.14MB 1.5s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 14.68MB / 42.14MB 1.7s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 17.83MB / 42.14MB 1.8s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 20.97MB / 42.14MB 2.0s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 26.21MB / 42.14MB 2.3s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 29.36MB / 42.14MB 2.4s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 32.51MB / 42.14MB 2.6s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 35.65MB / 42.14MB 2.7s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 38.80MB / 42.14MB 2.9s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 42.14MB / 42.14MB 3.0s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 42.14MB / 42.14MB 3.1s done
#4 extracting sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf
#4 extracting sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 1.3s done
#4 DONE 4.8s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c
#4 extracting sha256:f3f25b84a7d74315d94ee4108231f8f5e0cd2a44725a7204d5dd6ce91c151697 0.1s done
#4 DONE 4.8s

#5 [2/2] RUN echo 1
#5 0.276 1
#5 DONE 0.7s

#6 exporting to image
#6 exporting layers
#6 exporting layers 0.4s done
#6 exporting manifest sha256:638c9b50e4a78dffe2143eb8e2f4f2f11f00444b6df20380d7e04c40d47ea388
#6 exporting manifest sha256:638c9b50e4a78dffe2143eb8e2f4f2f11f00444b6df20380d7e04c40d47ea388 0.1s done
#6 exporting config sha256:3d66b10bcd8396f779df850024e5984e595c1582f8a041eb255436988745c0cf 0.1s done
#6 exporting attestation manifest sha256:3d7e6cdd561453a83c902be42c4e33dcd9f2a11ffe403ed7a5aa61a1a447a7a1 0.1s done
#6 exporting manifest list sha256:cee1924af1df916c1ece430ab2aff66ab657eb1e3d64cf692e07d98fee13421d
#6 exporting manifest list sha256:cee1924af1df916c1ece430ab2aff66ab657eb1e3d64cf692e07d98fee13421d 0.1s done
#6 naming to docker.io/library/buildx-demo:latest done
#6 unpacking to docker.io/library/buildx-demo:latest 0.1s done
#6 DONE 0.9s
root@buildx-0-38-1:~# docker images buildx-demo
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
buildx-demo:latest   cee1924af1df        159MB         42.1MB
```

### versions

```shell
root@buildx-0-38-1:~# docker buildx version
github.com/docker/buildx v0.38.1 0dbe87f36ed472fe36b6796c3f70b4210a731fc5
root@buildx-0-38-1:~# docker version --format '{{.Server.Version}}'
29.7.2
root@buildx-0-38-1:~# cat /etc/os-release
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
root@buildx-0-38-1:~# uname -a
Linux buildx-0-38-1 6.8.0-147-generic #147-Ubuntu SMP PREEMPT_DYNAMIC Thu Sep 24 11:33:16 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=buildx/v0.38.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildx-v0.38.1:ctr_v0.1.0
```
