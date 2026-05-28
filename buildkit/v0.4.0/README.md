# buildkit v0.4.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.4.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.4.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:buildkit-v0.4.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.4.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_buildkit-v0.4.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.4.0
$ ssh dqd-buildkit-v0.4.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.4.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-4-0:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-4-0:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
#1 [internal] load .dockerignore
#1       digest: sha256:d03e1b5eb6d6ad057670eef2c36dff00e8a9f087455503a895a8fdcaf3a9fa2f
#1         name: "[internal] load .dockerignore"
#1      started: 2026-05-28 01:23:48.951407808 +0000 UTC
#1 transferring context:
#1 transferring context: 2B done
#1    completed: 2026-05-28 01:23:49.539839817 +0000 UTC
#1     duration: 588.432009ms


#2 [internal] load build definition from Dockerfile
#2       digest: sha256:4ccbf989888e7b3aff2bd2addefb35a92b628372c1b3ae1e6f3758bf26278c02
#2         name: "[internal] load build definition from Dockerfile"
#2      started: 2026-05-28 01:23:48.951228954 +0000 UTC
#2    completed: 2026-05-28 01:23:49.545620608 +0000 UTC
#2     duration: 594.391654ms
#2 transferring dockerfile: 60B done


#3 [internal] load metadata for docker.io/library/ubuntu:latest
#3       digest: sha256:8c6bdfb121a69744f11ffa1fedfc68ec20085c2dcce567aac97a3ff72e53502d
#3         name: "[internal] load metadata for docker.io/library/ubuntu:latest"
#3      started: 2026-05-28 01:23:49.55146884 +0000 UTC
#3    completed: 2026-05-28 01:23:53.966216934 +0000 UTC
#3     duration: 4.414748094s


#4 [1/2] FROM docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c...
#4       digest: sha256:d0644a4396a5a2fecbf695a6bdae907a70c04d45dfdb0124c67a2e9ab24da01a
#4         name: "[1/2] FROM docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64"
#4      started: 2026-05-28 01:23:53.966725318 +0000 UTC
#4    completed: 2026-05-28 01:23:53.967026588 +0000 UTC
#4     duration: 301.27µs
#4      started: 2026-05-28 01:23:53.967077735 +0000 UTC
#4    completed: 2026-05-28 01:23:53.976131459 +0000 UTC
#4     duration: 9.053724ms
#4      started: 2026-05-28 01:23:53.976195472 +0000 UTC
#4 resolve docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 done
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 0B / 387B 0.1s
#4 sha256:30ba44506a6d003153c80023c4474e67d3487e9178df254bde55b19209cc8683 4.38kB / 4.38kB done
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 0B / 41.55MB 0.1s
#4 sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 6.69kB / 6.69kB done
#4 sha256:d31acef2a964b6df1f2b7e20a1525c4f2378024e087a4f8a8a9a4247e6a79573 1.39kB / 1.39kB done
#4 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 387B / 387B 1.0s done
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 2.26MB / 41.55MB 1.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 5.51MB / 41.55MB 2.1s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 8.60MB / 41.55MB 2.8s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 10.95MB / 41.55MB 3.4s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 13.42MB / 41.55MB 4.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 15.90MB / 41.55MB 4.6s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 18.55MB / 41.55MB 5.1s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 21.05MB / 41.55MB 5.5s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 23.46MB / 41.55MB 6.0s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 26.25MB / 41.55MB 6.4s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 29.31MB / 41.55MB 6.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 31.66MB / 41.55MB 7.3s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 34.27MB / 41.55MB 7.6s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 36.42MB / 41.55MB 7.9s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 38.51MB / 41.55MB 8.2s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 40.85MB / 41.55MB 8.7s
#4 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 41.55MB / 41.55MB 9.1s done
#4 unpacking docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#4    completed: 2026-05-28 01:24:05.001639186 +0000 UTC
#4     duration: 11.025443714s
#4 unpacking docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 1.9s done


#5 [2/2] RUN echo 1
#5       digest: sha256:21f198c9f4cbf92d91598b5daa663240ee03b14b8d1500d72455adbee0f3dc73
#5         name: "[2/2] RUN echo 1"
#5      started: 2026-05-28 01:24:05.003542905 +0000 UTC
#5 0.125 1
#5    completed: 2026-05-28 01:24:05.176216293 +0000 UTC
#5     duration: 172.673388ms
```

### versions

```shell
root@buildkit-0-4-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.4.0 c35410878ab9070498c66f6c67d3e8bc3b92241f
root@buildkit-0-4-0:~# runc --version
runc version 1.0.0-rc7
spec: 1.0.1-dev
root@buildkit-0-4-0:~# cat /etc/os-release
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
root@buildkit-0-4-0:~# uname -a
Linux buildkit-0-4-0 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=buildkit/v0.4.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.4.0:ctr_v0.1.0
```
