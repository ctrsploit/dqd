# ubuntu 14.04

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-14.04:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-14.04:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ubuntu-14.04_v0.2.0 | - |
| dqd | ssst0n3/docker_archive:ubuntu-14.04_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/ubuntu-14.04:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-14.04_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-14.04_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up ubuntu/14.04
$ ssh dqd-ubuntu-14.04
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ubuntu/14.04
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
$ ssh dqd-ubuntu-14.04
root@ubuntu14-04:~# uname -a
Linux ubuntu14-04 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu14-04:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
```

## build

```shell
make all ENV=ubuntu/14.04
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ubuntu-14.04:ctr_v0.2.0
```
