# shocker (docker v0.7.2)

* dqd: 
    * ghcr.io/ctrsploit/shocker-v0.7.2 -> ghcr.io/ctrsploit/shocker-v0.7.2:v0.1.0
    * ghcr.io/ctrsploit/shocker-v0.7.2:v0.1.0
* ctr: 
    * ghcr.io/ctrsploit/shocker-v0.7.2:ctr_v0.1.0 -> ghcr.io/ctrsploit/shocker-v0.7.2:ctr_v0.1.0:v0.1.0
    * ghcr.io/ctrsploit/shocker-v0.7.2:ctr_v0.1.0:v0.1.0

## reproduce

(docker v0.7.2 use registry v1, cannot pull image from dockerhub now.)

* There's the CAP_DAC_READ_SEARCH
* There's no `lxc.cap.drop` in config.lxc.

```shell
root@localhost:~# ./poc.sh
<!-- VERIFY -->
root@localhost:~# capsh --decode=fffffffc904cfeff
<!-- VERIFY -->
root@localhost:~# cat /var/lib/docker/containers/d63d09347bc3175efc657538cc33843b499e9fa647e694223d8714b86d9cb5aa/config.lxc |grep cap
<!-- VERIFY -->
```

## env

```shell
cd vul/shocker/shocker-v0.7.2
docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
ssh -p 12721 root@127.0.0.1
```

```shell
root@localhost:~# docker version
Client version: 0.7.2
Go version (client): go1.2
Git commit (client): 28b162e
Server version: 0.7.2
Git commit (server): 28b162e
Go version (server): go1.2
Last stable version: 17.05.0-ce, please update docker
root@localhost:~# lxc-version 
lxc version: 0.7.5
```

## build

```shell
make all ENV=vul/shocker/shocker-v0.7.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.7.2:ctr_v0.1.0:v0.1.0
```
