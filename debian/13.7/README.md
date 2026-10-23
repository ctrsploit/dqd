# debian 13.7

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/debian-13.7:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/debian-13.7:v0.1.0 | Debian 13.7 (trixie) base |
| ctr | ghcr.io/ctrsploit/debian-13.7:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up debian/13.7
$ ssh dqd-debian-13.7
```

Fallback without dqd CLI or SSH config:

```shell
$ cd debian/13.7
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@debian13-7:~# uname -a
<!-- VERIFY -->
root@debian13-7:~# cat /etc/os-release
<!-- VERIFY -->
```

## build

```shell
make all ENV=debian/13.7
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/debian-13.7:ctr_v0.1.0
```
