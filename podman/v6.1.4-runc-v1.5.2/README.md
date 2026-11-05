# podman v6.1.4 with runc v1.5.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:latest | points to `v0.1.1` |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:v0.1.1 | v0.1.0 with the runtime set through `/etc/containers/containers.conf.d/10-runtime.conf`: Fedora's vendor drop-in `00-vendor.conf` sets `[engine] runtime = "crun"` and is loaded after `/etc/containers/containers.conf`, so the bare config file was silently overridden (engine still resolved crun) |
| dqd | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:v0.1.0 | superseded: `[engine] runtime = "runc"` in `/etc/containers/containers.conf` had no effect |
| ctr | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:ctr_v0.1.1 | - |
| ctr | ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v6.1.4-runc-v1.5.2
$ ssh dqd-podman-v6.1.4-runc-v1.5.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v6.1.4-runc-v1.5.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman (runc)

```shell
[root@podman-6-1-4-runc-v1-5-2 ~]# podman info --format '{{.Host.OCIRuntime.Name}}'
<!-- VERIFY -->
[root@podman-6-1-4-runc-v1-5-2 ~]# podman run hello-world
<!-- VERIFY -->
```

### versions

```shell
[root@podman-6-1-4-runc-v1-5-2 ~]# podman version
<!-- VERIFY -->
[root@podman-6-1-4-runc-v1-5-2 ~]# runc --version
<!-- VERIFY -->
[root@podman-6-1-4-runc-v1-5-2 ~]# cat /etc/os-release
<!-- VERIFY -->
[root@podman-6-1-4-runc-v1-5-2 ~]# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=podman/v6.1.4-runc-v1.5.2
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v6.1.4-runc-v1.5.2:ctr_v0.1.0
```
