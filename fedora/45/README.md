# fedora 45

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/fedora-45:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/fedora-45:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/fedora-45:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up fedora/45
$ ssh dqd-fedora-45
```

Fallback without dqd CLI or SSH config:

```shell
$ cd fedora/45
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### versions

```shell
[root@fedora-45 ~]# cat /etc/os-release
NAME="Fedora Linux"
VERSION="45 (Container Image)"
RELEASE_TYPE=stable
ID=fedora
VERSION_ID=45
VERSION_CODENAME=""
PRETTY_NAME="Fedora Linux 45 (Container Image)"
ANSI_COLOR="0;38;2;60;110;180"
LOGO=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:45"
DEFAULT_HOSTNAME="fedora"
HOME_URL="https://fedoraproject.org/"
DOCUMENTATION_URL="https://docs.fedoraproject.org/en-US/fedora/f45/"
SUPPORT_URL="https://ask.fedoraproject.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_BUGZILLA_PRODUCT="Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=45
REDHAT_SUPPORT_PRODUCT="Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=45
SUPPORT_END=2027-12-08
VARIANT="Container Image"
VARIANT_ID=container
[root@fedora-45 ~]# uname -a
Linux fedora-45 7.2.15-300.fc45.x86_64 #1 SMP PREEMPT_DYNAMIC Sun Nov  1 16:11:16 UTC 2026 x86_64 GNU/Linux
```

## build

```shell
make all ENV=fedora/45
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/fedora-45:ctr_v0.1.0
```
