# debian 12.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/debian-12.0:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/debian-12.0:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:debian-12.0_v0.2.0 | install the built-in ssh key |
| dqd | ssst0n3/docker_archive:debian-12.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/debian-12.0:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_debian-12.0_v0.2.0 | install the built-in ssh key |
| ctr | ssst0n3/docker_archive:ctr_debian-12.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up debian/12.0
$ ssh dqd-debian-12.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd debian/12.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
$ ssh dqd-debian-12.0
root@debian12-0:~# uname -a
Linux debian12-0 6.1.0-47-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.170-3 (2026-05-08) x86_64 GNU/Linux
root@debian12-0:~# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
NAME="Debian GNU/Linux"
VERSION_ID="12"
VERSION="12 (bookworm)"
VERSION_CODENAME=bookworm
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```

## build

```shell
make all ENV=debian/12.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/debian-12.0:ctr_v0.2.0
```
