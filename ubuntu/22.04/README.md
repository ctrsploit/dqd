# ubuntu 22.04

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-22.04:latest | points to `v0.3.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-22.04:v0.3.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ubuntu-22.04_v0.3.0 | increase the VM size to 20G |
| dqd | ssst0n3/docker_archive:ubuntu-22.04_v0.2.0 | install built-in ssh key |
| dqd | ssst0n3/docker_archive:ubuntu-22.04_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/ubuntu-22.04:ctr_v0.3.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-22.04_v0.3.0 | increase the VM size to 20G |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-22.04_v0.2.0 | install built-in ssh key |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-22.04_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up ubuntu/22.04
$ ssh dqd-ubuntu-22.04
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ubuntu/22.04
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
$ ssh dqd-ubuntu-22.04
root@ubuntu22-04:~# uname -a
Linux ubuntu22-04 5.15.0-177-generic #187-Ubuntu SMP Sat Apr 11 22:54:33 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu22-04:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

## build

```shell
make all ENV=ubuntu/22.04
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ubuntu-22.04:ctr_v0.3.0
```
