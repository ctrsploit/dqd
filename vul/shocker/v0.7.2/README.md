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
<!-- VERIFY -->
root@shocker-v0-7-2:~# capsh --decode=fffffffc904cfeff
<!-- VERIFY -->
root@shocker-v0-7-2:~# cat /var/lib/docker/containers/d63d09347bc3175efc657538cc33843b499e9fa647e694223d8714b86d9cb5aa/config.lxc |grep cap
<!-- VERIFY -->
```

### versions

```shell
root@shocker-v0-7-2:~# docker version
<!-- VERIFY -->
root@shocker-v0-7-2:~# cat /etc/os-release
<!-- VERIFY -->
root@shocker-v0-7-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=vul/shocker/v0.7.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.7.2:ctr_v0.1.0
```
