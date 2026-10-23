# debian 13.7

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/debian-13.7:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/debian-13.7:v0.1.0 | Debian 13.7 (trixie) base |
| ctr | ghcr.io/ctrsploit/debian-13.7:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up debian/13.7
$ ssh dqd-debian-13.7
```

Fallback without dqd CLI or SSH config:

```shell
$ cd debian/13.7
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@debian13-7:~# uname -a
Linux debian13-7 6.12.113+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.113-1 (2026-10-15) x86_64 GNU/Linux
root@debian13-7:~# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.7
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```

## build

```shell
make all ENV=debian/13.7
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/debian-13.7:ctr_v0.1.0
```
