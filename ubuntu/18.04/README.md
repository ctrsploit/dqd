# ubuntu 18.04

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ubuntu-18.04:latest | points to `v0.3.0` |
| dqd | ghcr.io/ctrsploit/ubuntu-18.04:v0.3.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ubuntu-18.04_v0.2.0 | install the built-in ssh key |
| dqd | ssst0n3/docker_archive:ubuntu-18.04_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/ubuntu-18.04:ctr_v0.3.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-18.04_v0.2.0 | install the built-in ssh key |
| ctr | ssst0n3/docker_archive:ctr_ubuntu-18.04_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up ubuntu/18.04
$ ssh dqd-ubuntu-18.04
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ubuntu/18.04
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@ubuntu18-04:~# uname -a
Linux ubuntu18-04 4.15.0-213-generic #224-Ubuntu SMP Mon Jun 19 13:30:12 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu18-04:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.6 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.6 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
root@ubuntu18-04:~# cat /proc/filesystems
nodev   sysfs
nodev   rootfs
nodev   ramfs
nodev   bdev
nodev   proc
nodev   cpuset
nodev   cgroup
nodev   cgroup2
nodev   tmpfs
nodev   devtmpfs
nodev   configfs
nodev   debugfs
nodev   tracefs
nodev   securityfs
nodev   sockfs
nodev   dax
nodev   bpf
nodev   pipefs
nodev   hugetlbfs
nodev   devpts
        ext3
        ext2
        ext4
        squashfs
        vfat
nodev   ecryptfs
        fuseblk
nodev   fuse
nodev   fusectl
nodev   pstore
nodev   mqueue
nodev   autofs
nodev   aufs
```

## build

```shell
make all ENV=ubuntu/18.04
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ubuntu-18.04:ctr_v0.3.0
```
