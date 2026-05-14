# debian 11.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/debian-11.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/debian-11.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:debian-11.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/debian-11.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_debian-11.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up debian/11.0
$ ssh dqd-debian-11.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd debian/11.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@debian11-0:~# uname -a
Linux debian11-0 5.10.0-42-amd64 #1 SMP Debian 5.10.251-4 (2026-05-08) x86_64 GNU/Linux
root@debian11-0:~# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
VERSION_ID="11"
VERSION="11 (bullseye)"
VERSION_CODENAME=bullseye
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```

## build

```shell
make all ENV=debian/11.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/debian-11.0:ctr_v0.1.0
```
