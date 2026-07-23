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
<!-- VERIFY -->
root@shocker-v1-0-1-lxc:~# capsh --decode=00000000880425eb
<!-- VERIFY -->
root@shocker-v1-0-1-lxc:~# cat /var/lib/docker/containers/*/config.lxc | grep cap
<!-- VERIFY -->
```

### versions

```shell
root@shocker-v1-0-1-lxc:~# docker version
<!-- VERIFY -->
root@shocker-v1-0-1-lxc:~# lxc-start --version
<!-- VERIFY -->
root@shocker-v1-0-1-lxc:~# cat /etc/os-release
<!-- VERIFY -->
root@shocker-v1-0-1-lxc:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=vul/shocker/v1.0.1-lxc
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v1.0.1-lxc:ctr_v0.1.0
```
