# runc v1.1.0 (commit ab3cd8d)
| dqd | ghcr.io/ctrsploit/runc-v1.1.0-ab3cd8d:v0.2.0 | migrate from docker_archive |
$ dqd up runc/v1.1.0-ab3cd8d && ssh dqd-runc-v1.1.0-ab3cd8d
root@runc-1-1-0-ab3cd8d:~# runc --version
<!-- VERIFY -->
root@runc-1-1-0-ab3cd8d:~# cat /etc/os-release
<!-- VERIFY -->
root@runc-1-1-0-ab3cd8d:~# uname -a
<!-- VERIFY -->
```shell
make all ENV=runc/v1.1.0-ab3cd8d
```
