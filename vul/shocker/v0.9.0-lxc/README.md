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
<!-- VERIFY -->
root@shocker-v0-9-0-lxc:~# capsh --decode=fffffffc904ceeff
<!-- VERIFY -->
root@shocker-v0-9-0-lxc:~# cat /var/lib/docker/containers/d63d09347bc3175efc657538cc33843b499e9fa647e694223d8714b86d9cb5aa/config.lxc |grep cap
<!-- VERIFY -->
```

### versions

```shell
root@shocker-v0-9-0-lxc:~# docker version
<!-- VERIFY -->
root@shocker-v0-9-0-lxc:~# cat /etc/os-release
<!-- VERIFY -->
root@shocker-v0-9-0-lxc:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=vul/shocker/v0.9.0-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.9.0-lxc:ctr_v0.1.0
```
