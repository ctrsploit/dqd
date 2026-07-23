# shocker (docker v1.0.1 lxc)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/shocker-v1.0.1-lxc:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/shocker-v1.0.1-lxc:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:shocker_docker-v1.0.1-lxc_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/shocker-v1.0.1-lxc:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_shocker_docker-v1.0.1-lxc_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/shocker/v1.0.1-lxc
$ ssh dqd-shocker-v1.0.1-lxc
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/shocker/v1.0.1-lxc
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

(docker v1.0.1 use registry v1, cannot pull image from dockerhub now.)

* There's no CAP_DAC_READ_SEARCH
* There's no `lxc.cap.drop` in config.lxc.

```shell
root@shocker-v1-0-1-lxc:~# ./poc.sh
+ echo 'loading docker image, docker-v1.0.1 cannot pull images from registry v2 anymore.'
loading docker image, docker-v1.0.1 cannot pull images from registry v2 anymore.
+ docker load
+ docker run -ti busybox:1.36.1 grep Cap /proc/1/status
CapInh:	00000000880425eb
CapPrm:	00000000880425eb
CapEff:	00000000880425eb
CapBnd:	00000000880425eb
root@shocker-v1-0-1-lxc:~# capsh --decode=00000000880425eb
0x00000000880425eb=cap_chown,cap_dac_override,cap_fowner,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_setfcap
root@shocker-v1-0-1-lxc:~# cat /var/lib/docker/containers/*/config.lxc | grep cap
```

### versions

```shell
root@shocker-v1-0-1-lxc:~# docker version
Client version: 1.0.1
Client API version: 1.12
Go version (client): go1.2.1
Git commit (client): 990021a
Server version: 1.0.1
Server API version: 1.12
Go version (server): go1.2.1
Git commit (server): 990021a
root@shocker-v1-0-1-lxc:~# lxc-start --version
1.0.10
root@shocker-v1-0-1-lxc:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
root@shocker-v1-0-1-lxc:~# uname -a
Linux shocker-v1-0-1-lxc 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=vul/shocker/v1.0.1-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v1.0.1-lxc:ctr_v0.1.0
```
