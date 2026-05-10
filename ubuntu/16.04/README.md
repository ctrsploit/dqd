# ubuntu 16.04

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-16.04:latest | points to `v0.3.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-16.04:v0.3.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ubuntu-16.04_v0.2.0 | install the built-in ssh key |
| dqd | ssst0n3/docker_archive:ubuntu-16.04_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/ubuntu-16.04:ctr_v0.3.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-16.04_v0.2.0 | install the built-in ssh key |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-16.04_v0.1.0 | - |

## usage

```shell
$ cd ubuntu/16.04
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@ubuntu16-04:~# uname -a
Linux ubuntu16-04 4.4.0-210-generic #242-Ubuntu SMP Fri Apr 16 09:57:56 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu16-04:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.7 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.7 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
```

## build

```shell
make all ENV=ubuntu/16.04
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ubuntu-16.04:ctr_v0.3.0
```
