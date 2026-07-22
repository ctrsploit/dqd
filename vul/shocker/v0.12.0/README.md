# shocker (docker v0.12.0)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/shocker-v0.12.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/shocker-v0.12.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:shocker_docker-v0.12.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/shocker-v0.12.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_shocker_docker-v0.12.0_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/shocker/v0.12.0
$ ssh dqd-shocker-v0.12.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/shocker/v0.12.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

(docker v0.12.0 use registry v1, cannot pull image from dockerhub now.)

* There's no CAP_DAC_READ_SEARCH
* There's no config.lxc.

```shell
root@shocker-v0-12-0:~# ./poc.sh
+ echo 'loading docker image, docker-v0.12.0 cannot pull images from registry v2 anymore.'
loading docker image, docker-v0.12.0 cannot pull images from registry v2 anymore.
+ docker load
+ docker run -ti busybox:1.36.1 grep Cap /proc/1/status
CapInh:	00000000880425cb
CapPrm:	00000000880425cb
CapEff:	00000000880425cb
CapBnd:	00000000880425cb
root@shocker-v0-12-0:~# capsh --decode=00000000880425cb
0x00000000880425cb=cap_chown,cap_dac_override,cap_fowner,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_setfcap
root@shocker-v0-12-0:~# ls -lah /var/lib/docker/containers/*/
total 28K
drwx------ 2 root root 4.0K Jul 22 11:18 .
d--------- 3 root root 4.0K Jul 22 11:18 ..
-rw------- 1 root root  400 Jul 22 11:18 b878c83ff7aa51f2d2498266b0efdd2da97aae668356f3eb9299a8c6bf2607f2-json.log
-rw-r--r-- 1 root root 1.3K Jul 22 11:18 config.json
-rw-r--r-- 1 root root  192 Jul 22 11:18 hostconfig.json
-rw-r--r-- 1 root root   13 Jul 22 11:18 hostname
-rw-r--r-- 1 root root  174 Jul 22 11:18 hosts
```

### versions

```shell
root@shocker-v0-12-0:~# docker version
Client version: 0.12.0
Client API version: 1.12
Go version (client): go1.2.1
Git commit (client): 14680bf
Server version: 0.12.0
Server API version: 1.12
Go version (server): go1.2.1
Git commit (server): 14680bf
root@shocker-v0-12-0:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.6 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.6 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
root@shocker-v0-12-0:~# uname -a
Linux shocker-v0-12-0 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:40:49 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=vul/shocker/v0.12.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.12.0:ctr_v0.1.0
```
