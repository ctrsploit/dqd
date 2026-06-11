# shocker(docker v0.7.1)

* dqd: 
    * ghcr.io/ctrsploit/shocker-v0.7.1 -> ghcr.io/ctrsploit/shocker-v0.7.1:v0.1.0
    * ghcr.io/ctrsploit/shocker-v0.7.1:v0.1.0
* ctr: 
    * ghcr.io/ctrsploit/shocker-v0.7.1:ctr_v0.1.0  ghcr.io/ctrsploit/shocker-v0.7.1:ctr_v0.1.0 v0.1.0
    * ghcr.io/ctrsploit/shocker-v0.7.1:ctr_v0.1.0 v0.1.0

## reproduce

(docker v0.7.1 use registry v1, cannot pull image from dockerhub now.)

There's the CAP_DAC_READ_SEARCH

```shell
root@localhost:~# ./poc.sh
<!-- VERIFY -->
root@localhost:~# capsh --decode=fffffffc904cfeff
<!-- VERIFY -->
root@localhost:~# cat /var/lib/docker/containers/0cf0fee0e041b73eeb433695c9fb6469a993c75a6e7c998c1f8091a90c59eca7/config.lxc | grep cap
<!-- VERIFY -->
lxc.cap.drop = audit_control audit_write mac_admin mac_override mknod setpcap sys_admin sys_module sys_nice sys_pacct sys_rawio sys_resource sys_time sys_tty_config
```

## env

```shell
cd vul/shocker/shocker-v0.7.1
docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
ssh -p 12711 root@127.0.0.1
```

```shell
root@localhost:~# docker version
Client version: 0.7.1
Go version (client): go1.2
Git commit (client): 88df052
Server version: 0.7.1
Git commit (server): 88df052
Go version (server): go1.2
Last stable version: 17.05.0-ce, please update docker
root@localhost:~# lxc-version 
lxc version: 0.7.5
```

## build

```shell
make all ENV=vul/shocker/shocker-v0.7.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v0.7.1:ctr_v0.1.0 v0.1.0
```
