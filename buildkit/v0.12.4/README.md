# buildkit v0.12.4

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.12.4:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.12.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:buildkit-v0.12.4_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.12.4:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_buildkit-v0.12.4_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.12.4
$ ssh dqd-buildkit-v0.12.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.12.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-12-4:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-12-4:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 60B done
#1 DONE 0.2s

#2 [internal] load metadata for docker.io/library/ubuntu:latest
#2 DONE 5.0s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.2s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#4 resolve docker.io/library/ubuntu:latest@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 0.1s done
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 0B / 387B 0.2s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 0B / 41.55MB 0.2s
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 387B / 387B 0.6s done
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 2.10MB / 41.55MB 1.7s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 5.24MB / 41.55MB 2.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 7.34MB / 41.55MB 2.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 9.44MB / 41.55MB 2.6s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 12.58MB / 41.55MB 2.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 15.73MB / 41.55MB 3.2s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 18.87MB / 41.55MB 3.5s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 22.02MB / 41.55MB 3.8s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 24.12MB / 41.55MB 3.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 27.26MB / 41.55MB 4.2s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 29.36MB / 41.55MB 4.4s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 31.46MB / 41.55MB 4.5s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 34.60MB / 41.55MB 4.8s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 36.70MB / 41.55MB 5.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 38.80MB / 41.55MB 5.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 41.55MB / 41.55MB 5.5s done
#4 extracting sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54
#4 extracting sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 1.6s done
#4 extracting sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408
#4 extracting sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 0.1s done
#4 DONE 7.7s

#5 [2/2] RUN echo 1
#5 0.289 1
#5 DONE 1.1s
```

### versions

```shell
root@buildkit-0-12-4:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.12.4 833949d0f7908608b00ab6b93b8f92bdb147fcca
root@buildkit-0-12-4:~# runc --version
runc version 1.1.7
commit: v1.1.7-0-g860f061b
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
root@buildkit-0-12-4:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@buildkit-0-12-4:~# uname -a
Linux buildkit-0-12-4 5.15.0-179-generic #189-Ubuntu SMP Tue May 5 18:20:56 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=buildkit/v0.12.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.12.4:ctr_v0.1.0
```
