# buildkit v0.21.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.21.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.21.1:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:buildkit-v0.21.1_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.21.1:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_buildkit-v0.21.1_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.21.1
$ ssh dqd-buildkit-v0.21.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.21.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-21-1:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-21-1:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile:
#1 transferring dockerfile: 60B done
#1 DONE 1.2s

#2 [internal] load metadata for docker.io/library/ubuntu:latest
#2 DONE 4.0s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.1s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#4 resolve docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 0.1s done
#4 DONE 0.3s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 0B / 387B 0.2s
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 387B / 387B 0.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 0B / 41.55MB 0.2s
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 387B / 387B 0.8s done
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 2.10MB / 41.55MB 1.4s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 4.19MB / 41.55MB 1.7s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 6.29MB / 41.55MB 2.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 8.39MB / 41.55MB 2.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 10.49MB / 41.55MB 2.7s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 12.58MB / 41.55MB 3.2s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 14.68MB / 41.55MB 3.6s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 16.78MB / 41.55MB 3.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 18.87MB / 41.55MB 4.4s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 20.97MB / 41.55MB 5.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 23.07MB / 41.55MB 5.7s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 25.17MB / 41.55MB 6.5s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 27.26MB / 41.55MB 7.1s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 30.41MB / 41.55MB 7.5s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 32.51MB / 41.55MB 8.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 34.60MB / 41.55MB 8.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 36.70MB / 41.55MB 8.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 38.80MB / 41.55MB 9.5s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 41.55MB / 41.55MB 9.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 41.55MB / 41.55MB 10.1s done
#4 extracting sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54
#4 extracting sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 1.4s done
#4 DONE 11.9s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#4 extracting sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 0.1s done
#4 DONE 11.9s

#5 [2/2] RUN echo 1
#5 0.176 1
#5 DONE 1.6s
```

### versions

```shell
root@buildkit-0-21-1:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.21.1 66735c67040bc80e6ed104f451683e094030a4e1
root@buildkit-0-21-1:~# runc --version
runc version 1.2.6
commit: v1.2.6-0-ge89a2992
spec: 1.2.0
go: go1.23.7
libseccomp: 2.5.5
root@buildkit-0-21-1:~# cat /etc/os-release
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
root@buildkit-0-21-1:~# uname -a
Linux buildkit-0-21-1 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=buildkit/v0.21.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.21.1:ctr_v0.1.0
```
