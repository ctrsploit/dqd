# shocker (docker v0.11.1 lxc)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/shocker-v0.11.1-lxc:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/shocker-v0.11.1-lxc:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:shocker_docker-v0.11.1-lxc_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/shocker-v0.11.1-lxc:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_shocker_docker-v0.11.1-lxc_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/shocker/v0.11.1-lxc
$ ssh dqd-shocker-v0.11.1-lxc
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/shocker/v0.11.1-lxc
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

```shell
root@shocker-v0-11-1-lxc:~# ./poc.sh
+ echo 'loading docker image'
+ docker load
+ docker run -ti busybox:1.36.1 grep Cap /proc/1/status
root@shocker-v0-11-1-lxc:~# capsh --decode=00000018984ceeff
0x00000018984ceeff=cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_chroot,cap_sys_ptrace,cap_sys_boot,cap_mknod,cap_lease,cap_setfcap,cap_wake_alarm,cap_block_suspend
```

### versions

```shell
root@shocker-v0-11-1-lxc:~# docker version
Client version: 0.11.1
Server version: 0.11.1
root@shocker-v0-11-1-lxc:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
root@shocker-v0-11-1-lxc:~# uname -a
Linux shocker-v0-11-1-lxc 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=vul/shocker/v0.11.1-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.11.1-lxc:ctr_v0.1.0
```
