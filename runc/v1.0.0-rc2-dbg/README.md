# runc v1.0.0-rc2-dbg

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/runc-v1.0.0-rc2-dbg:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/runc-v1.0.0-rc2-dbg:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:runc-v1.0.0-rc2-dbg_v0.2.0 | - |
| dqd | ssst0n3/docker_archive:runc-v1.0.0-rc2-dbg_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/runc-v1.0.0-rc2-dbg:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.0.0-rc2-dbg_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_runc-v1.0.0-rc2-dbg_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up runc/v1.0.0-rc2-dbg
$ ssh dqd-runc-v1.0.0-rc2-dbg
```

Fallback without dqd CLI or SSH config:

```shell
$ cd runc/v1.0.0-rc2-dbg
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### 1. debug the runc main

start a runc command

```shell
root@runc-1-0-0-rc2-dbg:~# runc --version
API server listening at: [::]:2346
2025-05-12T13:54:45Z warning layer=rpc Listening for remote connections (connections are not authenticated nor encrypted)
....
```

connect it by dlv or a IDE

```shell
$ dlv connect 127.0.0.1:10026
Type 'help' for list of commands.
(dlv) c
Process 398 has exited with status 0
```

```shell
root@runc-1-0-0-rc2-dbg:~# runc --version
API server listening at: [::]:2346
2025-05-12T13:54:45Z warning layer=rpc Listening for remote connections (connections are not authenticated nor encrypted)
runc version 1.0.0-rc2
spec: 1.0.0-rc2-dev
```

### 2. debug the runc init

run a container, and connect it by dlv or a IDE

```shell
$ ./ssh
root@runc-1-0-0-rc2-dbg:~# runc run container-1
API server listening at: [::]:2346
2025-05-12T13:48:31Z warning layer=rpc Listening for remote connections (connections are not authenticated nor encrypted)
...
```

and then attach the init process

```shell
root@runc-1-0-0-rc2-dbg:~# ps -ef |grep init
root         1     0  0 12:57 ?        00:00:00 /sbin/init
root       457   450  0 13:05 pts/2    00:00:00 ./fd-listener_linux_amd64 -a /proc/self/exe -a init -d bundle
root       469   419  0 13:05 ?        00:00:00 /proc/self/exe init
root       476   406  0 13:05 pts/1    00:00:00 grep --color=auto init
root@runc-1-0-0-rc2-dbg:~# attach.sh 469
API server listening at: [::]:2347
2025-05-12T13:51:15Z warning layer=rpc Listening for remote connections (connections are not authenticated nor encrypted)
...
```

### versions

```shell
root@runc-1-0-0-rc2-dbg:~# runc --version
API server listening at: [::]:2346
2026-05-22T13:01:49Z warning layer=rpc Listening for remote connections (connections are not authenticated nor encrypted)
runc version 1.0.0-rc2
spec: 1.0.0-rc2-dev
root@runc-1-0-0-rc2-dbg:~# cat /etc/os-release
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
root@runc-1-0-0-rc2-dbg:~# uname -a
Linux runc-1-0-0-rc2-dbg 4.4.0-210-generic #242-Ubuntu SMP Fri Apr 16 09:57:56 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make dbg ENV=runc/v1.0.0-rc2-dbg
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/runc-v1.0.0-rc2-dbg:ctr_v0.1.0
```
