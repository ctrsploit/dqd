# nvidia-container-toolkit v1.12.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.12.0:latest | points to `v0.9.0` |
| dqd | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.12.0:v0.9.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nvidia-container-toolkit-v1.12.0_v0.9.0 | - |
| ctr | ghcr.io/ctrsploit/nvidia-container-toolkit-v1.12.0:ctr_v0.9.0 | install real nvidia driver without kernel module; install i386 libs; bump fake-nvidia to v0.7.2 |
| ctr | ssst0n3/docker_archive:ctr_nvidia-container-toolkit-v1.12.0_v0.9.0 | - |

## usage

### Start and connect

```shell
$ dqd up nvidia-container-toolkit/v1.12.0
$ ssh dqd-nvidia-container-toolkit-v1.12.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nvidia-container-toolkit/v1.12.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

https://web.archive.org/web/20230627162323/https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

### default mode(legacy)

```shell
root@nvidia-container-toolkit-1-12-0:~# docker run -tid --runtime=nvidia --gpus=all busybox
<!-- VERIFY -->
root@nvidia-container-toolkit-1-12-0:~# cat /run/containerd/io.containerd.runtime.v2.task/moby/<cid>/config.json | jq .hooks
<!-- VERIFY -->
```

### CDI mode

The `l.logger` field in v1.12.0, which was left uninitialized and could cause a panic, was fixed in [v1.13.0-rc.3](https://github.com/NVIDIA/nvidia-container-toolkit/commit/b2aaa21b0a1a4a9631f58bdd44bb678e15093b15).

https://github.com/NVIDIA/nvidia-container-toolkit/blob/v1.12.0/internal/lookup/library.go#L36-L68

```go
func NewLibraryLocator(logger *log.Logger, root string) (Locator, error) {
	...
	l := library{
		symlink: NewSymlinkLocator(logger, root),
		cache:   cache,
	}

	return &l, nil
}

// Locate finds the specified libraryname.
func (l library) Locate(libname string) ([]string, error) {
	...
	paths32, paths64 := l.cache.Lookup(libname)
	if len(paths32) > 0 {
		l.logger.Warnf("Ignoring 32-bit libraries for %v: %v", libname, paths32)
	}
  ...
}
```

```shell
root@nvidia-container-toolkit-1-12-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
```

The workaround is deleting `/lib/i386-linux-gnu/libnvidia-egl-gbm.so.1`.

```shell
root@nvidia-container-toolkit-1-12-0:~# rm /lib/i386-linux-gnu/libnvidia-egl-gbm.so.1
root@nvidia-container-toolkit-1-12-0:~# nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
<!-- VERIFY -->
```

### fake-nvidia

```shell
root@nvidia-container-toolkit-1-12-0:~# nvidia-container-cli info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-12-0:~# lsmod |grep fake
<!-- VERIFY -->
root@nvidia-container-toolkit-1-12-0:~# ls -lah /usr/lib/x86_64-linux-gnu/libnvidia-ml.so*
<!-- VERIFY -->
root@nvidia-container-toolkit-1-12-0:~# systemctl status fake-nvidia-device
<!-- VERIFY -->
```

### versions

```shell
root@nvidia-container-toolkit-1-12-0:~# nvidia-container-toolkit --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-12-0:~# docker info
<!-- VERIFY -->
root@nvidia-container-toolkit-1-12-0:~# containerd --version
<!-- VERIFY -->
root@nvidia-container-toolkit-1-12-0:~# cat /etc/os-release
<!-- VERIFY -->
root@nvidia-container-toolkit-1-12-0:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=nvidia-container-toolkit/v1.12.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nvidia-container-toolkit-v1.12.0:ctr_v0.9.0
```
