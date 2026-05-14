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

### Start and connect

Recommended:

```shell
$ dqd up centos/8
$ ssh dqd-centos-8
```

Fallback without dqd CLI or SSH config:

```shell
$ cd centos/8
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
$ ssh dqd-centos-8
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
[root@centos8 ~]# systemctl status
● centos8
    State: running
     Jobs: 0 queued
   Failed: 0 units
    Since: Tue 2026-05-12 06:48:34 UTC; 4min 1s ago
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 17
           └─system.slice
             ├─systemd-udevd.service
             │ └─503 /usr/lib/systemd/systemd-udevd
             ├─system-serial\x2dgetty.slice
             │ └─serial-getty@ttyS0.service
             │   └─570 /sbin/agetty -o -p -- \u --keep-baud 115200,38400,9600 ttyS0 vt220
             ├─systemd-journald.service
             │ └─465 /usr/lib/systemd/systemd-journald
             ├─sshd.service
             │ ├─574 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes25>
             │ ├─591 sshd: root [priv]
             │ ├─593 sshd: root@pts/0
             │ ├─594 -bash
             │ ├─617 systemctl status
             │ └─618 [less]
             ├─NetworkManager.service
             │ └─519 /usr/sbin/NetworkManager --no-daemon
             ├─dbus.service
             │ └─508 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --sysl>
             └─system-getty.slice
               └─getty@tty1.service
                 └─571 /sbin/agetty -o -p -- \u --noclear tty1 linux
```

## build

```shell
make all ENV=centos/8
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/centos-8:ctr_v0.2.0
```
