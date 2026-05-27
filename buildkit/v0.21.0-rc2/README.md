# buildkit v0.21.0-rc2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.21.0-rc2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.21.0-rc2:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:buildkit-v0.21.0-rc2_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.21.0-rc2:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_buildkit-v0.21.0-rc2_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.21.0-rc2
$ ssh dqd-buildkit-v0.21.0-rc2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.21.0-rc2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-21-0-rc2:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-21-0-rc2:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile:
#1 transferring dockerfile: 60B done
#1 DONE 0.5s

#2 [internal] load metadata for docker.io/library/ubuntu:latest
#2 DONE 4.1s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.1s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#4 resolve docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 0.1s done
#4 DONE 0.3s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 0B / 387B 0.2s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 0B / 41.55MB 0.2s
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 387B / 387B 0.5s done
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 3.15MB / 41.55MB 1.4s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 5.24MB / 41.55MB 1.5s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 7.34MB / 41.55MB 1.7s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 10.49MB / 41.55MB 2.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 12.58MB / 41.55MB 2.1s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 15.73MB / 41.55MB 2.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 17.83MB / 41.55MB 2.4s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 19.92MB / 41.55MB 2.6s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 22.02MB / 41.55MB 2.7s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 24.12MB / 41.55MB 2.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 26.21MB / 41.55MB 3.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 28.31MB / 41.55MB 3.2s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 31.46MB / 41.55MB 3.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 33.55MB / 41.55MB 3.5s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 37.75MB / 41.55MB 3.8s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 39.85MB / 41.55MB 3.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 41.55MB / 41.55MB 4.1s done
#4 extracting sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54
#4 extracting sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 1.5s done
#4 DONE 6.0s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#4 extracting sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 0.1s done
#4 DONE 6.1s

#5 [2/2] RUN echo 1
#5 0.178 1
#5 DONE 0.7s
```

### versions

```shell
root@buildkit-0-21-0-rc2:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.21.0-rc2 52b004d2afe20c5c80967cc1784e718b52d69dae
root@buildkit-0-21-0-rc2:~# runc --version
runc version 1.2.6
commit: v1.2.6-0-ge89a2992
spec: 1.2.0
go: go1.23.7
libseccomp: 2.5.5
root@buildkit-0-21-0-rc2:~# cat /etc/os-release
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
root@buildkit-0-21-0-rc2:~# uname -a
Linux buildkit-0-21-0-rc2 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=buildkit/v0.21.0-rc2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.21.0-rc2:ctr_v0.1.0
```
