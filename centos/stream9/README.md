# centos stream9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/centos-stream9:latest | points to `v0.2.0` |
| dqd | ghcr.io/ctrsploit/centos-stream9:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:centos-stream9_v0.2.0 | install the built-in ssh keys |
| dqd | ssst0n3/docker_archive:centos-stream9_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/centos-stream9:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_centos-stream9_v0.2.0 | install the built-in ssh keys |
| ctr | ssst0n3/docker_archive:ctr_centos-stream9_v0.1.0 | - |

## usage

```shell
$ cd centos/stream9
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

```shell
$ ./ssh
[root@centos-stream9 ~]# uname -a
Linux centos-stream9 5.14.0-701.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Mon May 4 09:10:57 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
[root@centos-stream9 ~]# cat /etc/os-release
NAME="CentOS Stream"
VERSION="9"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="9"
PLATFORM_ID="platform:el9"
PRETTY_NAME="CentOS Stream 9"
ANSI_COLOR="0;31"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:centos:centos:9"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://issues.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 9"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
[root@centos-stream9 ~]# systemctl status
● centos-stream9
    State: running
    Units: 205 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Tue 2026-05-12 07:38:00 UTC; 1min 25s ago
  systemd: 252-69.el9
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
           ├─system.slice
           │ ├─NetworkManager.service
           │ │ └─543 /usr/sbin/NetworkManager --no-daemon
           │ ├─dbus-broker.service
           │ │ ├─541 /usr/bin/dbus-broker-launch --scope system --audit
           │ │ └─542 dbus-broker --log 4 --controller 9 --machine-id ae25e19dc5ed4e519609d795a891ce92 --max
-bytes 536870912 --max-fds 4096 --max-matches 131072 --audit
           │ ├─sshd.service
           │ │ └─581 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
           │ ├─system-getty.slice
           │ │ └─getty@tty1.service
           │ │   └─573 /sbin/agetty -o "-p -- \\u" --noclear - linux
           │ ├─system-serial\x2dgetty.slice
           │ │ └─serial-getty@ttyS0.service
           │ │   └─574 /sbin/agetty -o "-p -- \\u" --keep-baud 115200,57600,38400,9600 - vt220
           │ ├─systemd-journald.service
           │ │ └─482 /usr/lib/systemd/systemd-journald
           │ ├─systemd-logind.service
           │ │ └─548 /usr/lib/systemd/systemd-logind
           │ └─systemd-udevd.service
           │   └─udev
           │     └─504 /usr/lib/systemd/systemd-udevd
           └─user.slice
             └─user-0.slice
               ├─session-1.scope
               │ ├─583 "sshd-session: root [priv]"
               │ ├─596 "sshd-session: root@pts/0"
               │ ├─597 -bash
               │ ├─616 systemctl status
               │ └─617 more
               └─user@0.service
                 └─init.scope
                   ├─587 /usr/lib/systemd/systemd --user
                   └─589 "(sd-pam)"
```

## build

```shell
make all ENV=centos/stream9
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/centos-stream9:ctr_v0.2.0
```
