# shocker (docker v1.0.0 lxc)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/shocker-v1.0.0-lxc:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/shocker-v1.0.0-lxc:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:shocker_docker-v1.0.0-lxc_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/shocker-v1.0.0-lxc:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_shocker_docker-v1.0.0-lxc_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/shocker/v1.0.0-lxc
$ ssh dqd-shocker-v1.0.0-lxc
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/shocker/v1.0.0-lxc
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

(docker v1.0.0 use registry v1, cannot pull image from dockerhub now.)

* There's CAP_DAC_READ_SEARCH
* There's no `lxc.cap.drop` in config.lxc.

```shell
root@shocker-v1-0-0-lxc:~# ./poc.sh
+ echo 'loading docker image, docker-v1.0.0 cannot pull images from registry v2 anymore.'
loading docker image, docker-v1.0.0 cannot pull images from registry v2 anymore.
+ docker load
+ docker run -ti busybox:1.36.1 grep Cap /proc/1/status
CapInh:	0000000000000000
CapPrm:	00000018984ceeff
CapEff:	00000018984ceeff
CapBnd:	00000018984ceeff
root@shocker-v1-0-0-lxc:~# capsh --decode=00000018984ceeff
0x00000018984ceeff=cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_chroot,cap_sys_ptrace,cap_sys_boot,cap_mknod,cap_lease,cap_setfcap,cap_wake_alarm,cap_block_suspend
root@shocker-v1-0-0-lxc:~# cat /var/lib/docker/containers/*/config.lxc | grep cap
```

### versions

```shell
root@shocker-v1-0-0-lxc:~# docker version
Client version: 1.0.0
Client API version: 1.12
Go version (client): go1.2.1
Git commit (client): 63fe64c
Server version: 1.0.0
Server API version: 1.12
Go version (server): go1.2.1
Git commit (server): 63fe64c
root@shocker-v1-0-0-lxc:~# lxc-start --version
1.0.10
root@shocker-v1-0-0-lxc:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
root@shocker-v1-0-0-lxc:~# uname -a
Linux shocker-v1-0-0-lxc 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=vul/shocker/v1.0.0-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v1.0.0-lxc:ctr_v0.1.0
```
