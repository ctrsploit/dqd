# shocker (docker v0.7.2)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/shocker-v0.7.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/shocker-v0.7.2:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:shocker_docker-v0.7.2_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/shocker-v0.7.2:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_shocker_docker-v0.7.2_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/shocker/v0.7.2
$ ssh dqd-shocker-v0.7.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/shocker/v0.7.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

```shell
root@shocker-v0-7-2:~# ./poc.sh
+ echo 'loading docker image'
+ docker load
+ docker run -t -i busybox:ubuntu-12.04 grep Cap /proc/1/status
root@shocker-v0-7-2:~# capsh --decode=fffffffc904cfeff
0xfffffffc904cfeff=cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_chroot,cap_sys_ptrace,cap_sys_boot,cap_lease,cap_setfcap,cap_syslog,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
root@shocker-v0-7-2:~# cat /var/lib/docker/containers/*/config.lxc |grep cap
<!-- VERIFY -->
```

### versions

```shell
root@shocker-v0-7-2:~# docker version
Client version: 0.7.2
Server version: 0.7.2
root@shocker-v0-7-2:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="12.04.5 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.5 LTS)"
VERSION_ID="12.04"
root@shocker-v0-7-2:~# uname -a
Linux shocker-v0-7-2 3.2.0-150-virtual #197-Ubuntu SMP Mon Apr 5 23:03:53 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=vul/shocker/v0.7.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.7.2:ctr_v0.1.0
```
