# ubuntu 12.04

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-12.04:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-12.04:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ubuntu-12.04_v0.2.0 | install the built-in ssh key |
| dqd | ssst0n3/docker_archive:ubuntu-12.04_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/ubuntu-12.04:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-12.04_v0.2.0 | install the built-in ssh key |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-12.04_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up ubuntu/12.04
$ ssh dqd-ubuntu-12.04
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ubuntu/12.04
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@ubuntu12-04:~# uname -a
Linux ubuntu12-04 3.2.0-150-virtual #197-Ubuntu SMP Mon Apr 5 23:03:53 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu12-04:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="12.04.5 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.5 LTS)"
VERSION_ID="12.04"
```

## build

```shell
make all ENV=ubuntu/12.04
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ubuntu-12.04:ctr_v0.2.0
```
