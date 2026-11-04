# fedora 45

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/fedora-45:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/fedora-45:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/fedora-45:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up fedora/45
$ ssh dqd-fedora-45
```

Fallback without dqd CLI or SSH config:

```shell
$ cd fedora/45
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### versions

```shell
[root@fedora-45 ~]# cat /etc/os-release
<!-- VERIFY -->
[root@fedora-45 ~]# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=fedora/45
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/fedora-45:ctr_v0.1.0
```
