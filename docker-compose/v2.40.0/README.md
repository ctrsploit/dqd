# docker-compose v2.40.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/docker-compose-v2.40.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/docker-compose-v2.40.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:docker-compose-v2.40.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/docker-compose-v2.40.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_docker-compose-v2.40.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up docker-compose/v2.40.0
$ ssh dqd-docker-compose-v2.40.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd docker-compose/v2.40.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### docker compose

```shell
root@docker-compose-2-40-0:~# docker compose version
Docker Compose version v2.40.0
```

### versions

```shell
root@docker-compose-2-40-0:~# docker --version
Docker version 28.3.2, build 578ccf6
root@docker-compose-2-40-0:~# containerd --version
containerd containerd.io 1.7.27 05044ec0a9a75232cad458027ca83437aae3f4da
root@docker-compose-2-40-0:~# cat /etc/os-release
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
root@docker-compose-2-40-0:~# uname -a
Linux docker-compose-2-40-0 6.8.0-124-generic #124-Ubuntu SMP PREEMPT_DYNAMIC Tue May 26 13:00:45 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=docker-compose/v2.40.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/docker-compose-v2.40.0:ctr_v0.1.0
```
