# shocker (docker v26.1.4)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/shocker-v26.1.4:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/shocker-v26.1.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:shocker_docker-v26.1.4_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/shocker-v26.1.4:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_shocker_docker-v26.1.4_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/shocker/v26.1.4
$ ssh dqd-shocker-v26.1.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/shocker/v26.1.4
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

```shell
root@shocker-v26-1-4:~# ./poc.sh
<!-- VERIFY -->
```

### versions

```shell
root@shocker-v26-1-4:~# docker version
<!-- VERIFY -->
root@shocker-v26-1-4:~# cat /etc/os-release
<!-- VERIFY -->
root@shocker-v26-1-4:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=vul/shocker/v26.1.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v26.1.4:ctr_v0.1.0
```
