# centos 8

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/centos-8:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/centos-8:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:centos-8_v0.2.0 | install the built-in ssh key |
| dqd | ssst0n3/docker_archive:centos-8_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/centos-8:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_centos-8_v0.2.0 | install the built-in ssh key |
| ctr | ssst0n3/docker_archive:ctr_centos-8_v0.1.0 | - |

## usage

```shell
$ cd centos/8
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

```shell
$ ./ssh
[root@centos8 ~]# uname -a
Linux centos8 4.18.0-348.7.1.el8_5.x86_64 #1 SMP Wed Dec 22 13:25:12 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
[root@centos8 ~]# cat /etc/os-release
NAME="CentOS Linux"
VERSION="8"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="8"
PLATFORM_ID="platform:el8"
PRETTY_NAME="CentOS Linux 8"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:8"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"
CENTOS_MANTISBT_PROJECT="CentOS-8"
CENTOS_MANTISBT_PROJECT_VERSION="8"
```

## build

```shell
make all ENV=centos/8
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/centos-8:ctr_v0.2.0
```
