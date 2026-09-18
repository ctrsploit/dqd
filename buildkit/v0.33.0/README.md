# buildkit v0.33.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/buildkit-v0.33.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/buildkit-v0.33.0:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/buildkit-v0.33.0:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up buildkit/v0.33.0
$ ssh dqd-buildkit-v0.33.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd buildkit/v0.33.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Build images with buildctl

```shell
root@buildkit-0-33-0:~# cat <<EOF >Dockerfile
FROM ubuntu
RUN echo 1
EOF
root@buildkit-0-33-0:~# buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. --progress=plain
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 60B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/ubuntu:latest
#2 DONE 3.2s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:9559ceb7c21e528e233e8dff26a0fb2682f4094cce06176eeb075d87a22b31de
#4 resolve docker.io/library/ubuntu:latest@sha256:9559ceb7c21e528e233e8dff26a0fb2682f4094cce06176eeb075d87a22b31de 0.0s done
#4 DONE 0.1s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:9559ceb7c21e528e233e8dff26a0fb2682f4094cce06176eeb075d87a22b31de
#4 sha256:d9b9856437537fc061e98f71ecab9d95d7745fbf7d7b871d2e54ca4c3b02ea5a 0B / 391B 0.2s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 0B / 41.57MB 0.2s
#4 sha256:d9b9856437537fc061e98f71ecab9d95d7745fbf7d7b871d2e54ca4c3b02ea5a 391B / 391B 0.5s done
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 2.10MB / 41.57MB 1.2s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 5.24MB / 41.57MB 1.4s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 7.34MB / 41.57MB 1.5s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 9.44MB / 41.57MB 1.7s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 11.53MB / 41.57MB 1.8s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 13.63MB / 41.57MB 2.0s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 15.73MB / 41.57MB 2.1s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 17.83MB / 41.57MB 2.3s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 20.97MB / 41.57MB 2.6s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 24.12MB / 41.57MB 2.9s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 27.26MB / 41.57MB 3.2s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 29.36MB / 41.57MB 3.3s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 32.51MB / 41.57MB 3.6s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 34.60MB / 41.57MB 3.8s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 36.70MB / 41.57MB 3.9s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 38.80MB / 41.57MB 4.1s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 40.89MB / 41.57MB 4.4s
#4 sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 41.57MB / 41.57MB 4.4s done
#4 extracting sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e
#4 extracting sha256:09923199ca0ebd3ad9fb1dd1d0ab85d2b86aa388b988c8d4c8ee4f660fdb9e9e 1.7s done
#4 DONE 6.2s

#4 [1/2] FROM docker.io/library/ubuntu:latest@sha256:9559ceb7c21e528e233e8dff26a0fb2682f4094cce06176eeb075d87a22b31de
#4 extracting sha256:d9b9856437537fc061e98f71ecab9d95d7745fbf7d7b871d2e54ca4c3b02ea5a 0.0s done
#4 DONE 6.2s

#5 [2/2] RUN echo 1
#5 0.146 1
#5 DONE 0.5s
```

### versions

```shell
root@buildkit-0-33-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.33.0 dddd5621af04ea57823085c93a063383f71d3173
root@buildkit-0-33-0:~# runc --version
runc version 1.4.3
commit: v1.4.3-0-gbb14dabeb
spec: 1.3.0
go: go1.25.11
libseccomp: 2.6.0
root@buildkit-0-33-0:~# cat /etc/os-release
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
root@buildkit-0-33-0:~# uname -a
Linux buildkit-0-33-0 6.8.0-139-generic #139-Ubuntu SMP PREEMPT_DYNAMIC Sat Aug  1 03:52:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=buildkit/v0.33.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/buildkit-v0.33.0:ctr_v0.1.0
```
