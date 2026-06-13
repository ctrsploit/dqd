# shocker (docker v0.9.0 lxc)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/shocker-v0.9.0-lxc:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/shocker-v0.9.0-lxc:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:shocker_docker-v0.9.0-lxc_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/shocker-v0.9.0-lxc:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_shocker_docker-v0.9.0-lxc_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/shocker/v0.9.0-lxc
$ ssh dqd-shocker-v0.9.0-lxc
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/shocker/v0.9.0-lxc
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

(docker v0.9.0 use registry v1, cannot pull image from dockerhub now.)

```shell
root@shocker-v0-9-0-lxc:~# ./poc.sh
+ echo 'loading docker image, docker-v0.9.0 cannot pull images from registry v2 anymore.'
loading docker image, docker-v0.9.0 cannot pull images from registry v2 anymore.
+ docker load
+ docker run -t -i busybox:ubuntu-12.04 grep Cap /proc/1/status
root@shocker-v0-9-0-lxc:~# capsh --decode=fffffffc904ceeff
0xfffffffc904ceeff=cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_chroot,cap_sys_ptrace,cap_sys_boot,cap_lease,cap_setfcap,cap_syslog,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
root@shocker-v0-9-0-lxc:~# cat /var/lib/docker/containers/*/config.lxc |grep cap
```

### versions

```shell
root@shocker-v0-9-0-lxc:~# docker version
Client version: 0.9.0
Server version: 0.9.0
root@shocker-v0-9-0-lxc:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="12.04.5 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.5 LTS)"
VERSION_ID="12.04"
root@shocker-v0-9-0-lxc:~# uname -a
Linux shocker-v0-9-0-lxc 3.2.0-150-virtual #197-Ubuntu SMP Mon Apr 5 23:03:53 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=vul/shocker/v0.9.0-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.9.0-lxc:ctr_v0.1.0
```
