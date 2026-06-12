# shocker (docker v0.9.0)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/shocker-v0.9.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/shocker-v0.9.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:shocker_docker-v0.9.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/shocker-v0.9.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_shocker_docker-v0.9.0_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/shocker/v0.9.0
$ ssh dqd-shocker-v0.9.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/shocker/v0.9.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

(docker v0.9.0 use registry v1, cannot pull image from dockerhub now.)

```shell
root@shocker-v0-9-0:~# ./poc.sh
<!-- VERIFY -->
root@shocker-v0-9-0:~# capsh --decode=fffffffc904ceeff
<!-- VERIFY -->
root@shocker-v0-9-0:~# cat /var/lib/docker/containers/*/config.env | grep cap
<!-- VERIFY -->
```

### versions

```shell
root@shocker-v0-9-0:~# docker version
<!-- VERIFY -->
root@shocker-v0-9-0:~# cat /etc/os-release
<!-- VERIFY -->
root@shocker-v0-9-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=vul/shocker/v0.9.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.9.0:ctr_v0.1.0
```
