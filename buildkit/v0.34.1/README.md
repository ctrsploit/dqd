# buildkit v0.34.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.34.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.34.1:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.34.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.34.1
$ ssh dqd-buildkit-v0.34.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.34.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-34-1:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-34-1:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 60B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/ubuntu:latest
#2 DONE 3.6s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c
#4 resolve docker.io/library/ubuntu:latest@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c 0.0s done
#4 sha256:f3f25b84a7d74315d94ee4108231f8f5e0cd2a44725a7204d5dd6ce91c151697 0B / 392B 0.2s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 0B / 42.14MB 0.2s
#4 sha256:f3f25b84a7d74315d94ee4108231f8f5e0cd2a44725a7204d5dd6ce91c151697 392B / 392B 0.5s done
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 3.15MB / 42.14MB 1.5s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 8.39MB / 42.14MB 1.8s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 13.63MB / 42.14MB 2.1s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 16.78MB / 42.14MB 2.3s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 19.92MB / 42.14MB 2.4s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 25.17MB / 42.14MB 2.7s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 28.31MB / 42.14MB 2.9s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 33.55MB / 42.14MB 3.2s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 36.70MB / 42.14MB 3.5s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 39.85MB / 42.14MB 3.8s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 42.14MB / 42.14MB 3.9s
#4 sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 42.14MB / 42.14MB 4.5s done
#4 extracting sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf
#4 extracting sha256:edafa32f5d9e4d9629f0dbc6c01e63c79ff08133c01cfb7d3363aa8bd8a614cf 2.4s done
#4 DONE 7.0s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c
#4 extracting sha256:f3f25b84a7d74315d94ee4108231f8f5e0cd2a44725a7204d5dd6ce91c151697 0.1s done
#4 DONE 7.0s

#5 [2/2] RUN echo 1
#5 0.190 1
#5 DONE 0.5s
```

### versions

```shell
root@buildkit-0-34-1:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.34.1 f5b59a1f2fb25a0cb7072c398cab9aed7835da4e
root@buildkit-0-34-1:~# runc --version
runc version 1.5.2
commit: v1.5.2-0-g29dd3dc
spec: 1.3.0
go: go1.26.8
libseccomp: 2.6.1
libpathrs: 0.2.6
root@buildkit-0-34-1:~# cat /etc/os-release
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
root@buildkit-0-34-1:~# uname -a
Linux buildkit-0-34-1 6.8.0-147-generic #147-Ubuntu SMP PREEMPT_DYNAMIC Thu Sep 24 11:33:16 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=buildkit/v0.34.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.34.1:ctr_v0.1.0
```
