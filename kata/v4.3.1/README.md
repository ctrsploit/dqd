# kata v4.3.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kata-v4.3.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kata-v4.3.1:v0.1.0 | Kata Containers 4.3.1 (runtime-rs + QEMU) on Docker 29.9.2 / Debian 13.7 |
| ctr | ghcr.io/ctrsploit/kata-v4.3.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kata/v4.3.1
$ ssh dqd-kata-v4.3.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kata/v4.3.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a Kata container

Kata requires `/dev/kvm` and nested virtualization. The compose command starts
the lab VM with `-cpu host`, so the host must expose `vmx`/`svm` to `/dev/kvm`.

```shell
root@kata-4-3-1:~# docker run --runtime kata --rm ubuntu uname -r
<!-- VERIFY -->
```

### versions

```shell
root@kata-4-3-1:~# docker version
<!-- VERIFY -->
root@kata-4-3-1:~# docker info --format '{{json .Runtimes}}'
<!-- VERIFY -->
root@kata-4-3-1:~# uname -a
<!-- VERIFY -->
root@kata-4-3-1:~# cat /etc/os-release
<!-- VERIFY -->
```

## build

```shell
make all ENV=kata/v4.3.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/kata-v4.3.1:ctr_v0.1.0
```
