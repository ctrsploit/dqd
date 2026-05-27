# buildkit v0.3.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.3.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.3.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:buildkit-v0.3.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.3.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_buildkit-v0.3.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.3.0
$ ssh dqd-buildkit-v0.3.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.3.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-3-0:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-3-0:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
#1 [internal] load build definition from Dockerfile
#1       digest: sha256:29a6e827679eaa8575c5642068cef87aa20f8a5d3c493eadad074ab156db5863
#1         name: "[internal] load build definition from Dockerfile"
#1      started: 2026-05-27 10:04:18.181022472 +0000 UTC
#1    completed: 2026-05-27 10:04:18.380255245 +0000 UTC
#1     duration: 199.232773ms
#1 transferring dockerfile: 60B done


#2 [internal] load .dockerignore
#2       digest: sha256:fce4d5dbabbc89033d381b03deabc3697bdb00407887e31caa477a26fc92a6a0
#2         name: "[internal] load .dockerignore"
#2      started: 2026-05-27 10:04:18.347131256 +0000 UTC
#2    completed: 2026-05-27 10:04:18.392642072 +0000 UTC
#2     duration: 45.510816ms
#2 transferring context: 2B done


#3 [internal] load metadata for docker.io/library/ubuntu:latest
#3       digest: sha256:8c6bdfb121a69744f11ffa1fedfc68ec20085c2dcce567aac97a3ff72e53502d
#3         name: "[internal] load metadata for docker.io/library/ubuntu:latest"
#3      started: 2026-05-27 10:04:18.395972785 +0000 UTC
#3    completed: 2026-05-27 10:04:22.592166712 +0000 UTC
#3     duration: 4.196193927s


#5 [1/2] FROM docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c...
#5       digest: sha256:d0644a4396a5a2fecbf695a6bdae907a70c04d45dfdb0124c67a2e9ab24da01a
#5         name: "[1/2] FROM docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64"
#5      started: 2026-05-27 10:04:22.592525495 +0000 UTC
#5    completed: 2026-05-27 10:04:22.592643075 +0000 UTC
#5     duration: 117.58µs
#5      started: 2026-05-27 10:04:22.593812323 +0000 UTC
#5    completed: 2026-05-27 10:04:22.602542213 +0000 UTC
#5     duration: 8.72989ms
#5      started: 2026-05-27 10:04:22.602605423 +0000 UTC
#5 resolve docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 done
#5 sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 6.69kB / 6.69kB done
#5 sha256:d31acef2a964b6df1f2b7e20a1525c4f2378024e087a4f8a8a9a4247e6a79573 1.39kB / 1.39kB done
#5 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 0B / 387B 0.1s
#5 sha256:30ba44506a6d003153c80023c4474e67d3487e9178df254bde55b19209cc8683 4.38kB / 4.38kB done
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 0B / 41.55MB 0.1s
#5 sha256:1c24335ddd46023ff99bd665bd8ea6798464f7bbf501718edcf2eb4696e5f408 387B / 387B 1.0s done
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 3.32MB / 41.55MB 1.5s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 5.41MB / 41.55MB 1.6s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 8.01MB / 41.55MB 1.8s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 11.04MB / 41.55MB 2.1s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 14.94MB / 41.55MB 2.4s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 19.05MB / 41.55MB 2.7s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 21.28MB / 41.55MB 2.8s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 23.42MB / 41.55MB 3.0s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 25.87MB / 41.55MB 3.3s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 29.48MB / 41.55MB 3.6s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 32.22MB / 41.55MB 3.9s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 34.47MB / 41.55MB 4.0s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 38.14MB / 41.55MB 4.3s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 40.23MB / 41.55MB 4.5s
#5 sha256:6f5c5aa4e145204b113f983c003ff8ad6489394294ef95ec030bc94e3daded54 41.55MB / 41.55MB 4.8s done
#5 unpacking docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
#5 unpacking docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 1.8s done
#5    completed: 2026-05-27 10:04:29.242702829 +0000 UTC
#5     duration: 6.640097406s


#4 [2/2] RUN echo 1
#4       digest: sha256:21f198c9f4cbf92d91598b5daa663240ee03b14b8d1500d72455adbee0f3dc73
#4         name: "[2/2] RUN echo 1"
#4      started: 2026-05-27 10:04:29.244615964 +0000 UTC
#4 0.105 1
#4    completed: 2026-05-27 10:04:29.638827235 +0000 UTC
#4     duration: 394.211271ms
```

### versions

```shell
root@buildkit-0-3-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.3.0 663f185a07b532664020d616b0e55873c2741307
root@buildkit-0-3-0:~# runc --version
runc version 1.0.0-rc6
spec: 1.0.1-dev
root@buildkit-0-3-0:~# cat /etc/os-release
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
root@buildkit-0-3-0:~# uname -a
Linux buildkit-0-3-0 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=buildkit/v0.3.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.3.0:ctr_v0.1.0
```
