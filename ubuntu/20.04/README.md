# ubuntu 20.04

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-20.04:latest | points to `v0.3.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-20.04:v0.3.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ubuntu-20.04_v0.2.0 | install the built-in ssh key |
| dqd | ssst0n3/docker_archive:ubuntu-20.04_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/ubuntu-20.04:ctr_v0.3.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-20.04_v0.2.0 | install the built-in ssh key |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-20.04_v0.1.0 | - |

## usage

```shell
$ cd ubuntu/20.04
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@ubuntu20-04:~# uname -a
Linux ubuntu20-04 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu20-04:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.6 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.6 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```

## build

```shell
make all ENV=ubuntu/20.04
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ubuntu-20.04:ctr_v0.3.0
```
