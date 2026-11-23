# firecracker v1.16.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/firecracker-v1.16.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/firecracker-v1.16.1:v0.1.0 | Firecracker 1.16.1 (+ jailer) on Ubuntu 24.04 |
| ctr | ghcr.io/ctrsploit/firecracker-v1.16.1:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up firecracker/v1.16.1
$ ssh dqd-firecracker-v1.16.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd firecracker/v1.16.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Boot a microVM

Firecracker requires `/dev/kvm` and nested virtualization. The compose command
starts the lab VM with `-cpu host`, so the host must expose `vmx`/`svm` to
`/dev/kvm`. Guest assets live in `/opt/firecracker/` (firecracker CI kernel
and Ubuntu 22.04 rootfs).

```shell
root@firecracker-1-16-1:~# cat > boot.json <<'EOF'
{
  "boot-source": {
    "kernel_image_path": "/opt/firecracker/vmlinux-6.1.102",
    "boot_args": "console=ttyS0 reboot=k panic=1 pci=off root=/dev/vda rw"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "/opt/firecracker/ubuntu-22.04.ext4",
      "is_root_device": true,
      "is_read_only": false
    }
  ]
}
EOF
root@firecracker-1-16-1:~# firecracker --api-sock /tmp/fc.sock &
root@firecracker-1-16-1:~# curl --unix-socket /tmp/fc.sock -X PUT \
    'localhost/vm' -H 'Content-Type: application/json' \
    --data-binary @boot.json
<!-- VERIFY -->
root@firecracker-1-16-1:~# curl --unix-socket /tmp/fc.sock -X PUT \
    'localhost/actions' -H 'Content-Type: application/json' \
    -d '{"action_type": "InstanceStart"}'
<!-- VERIFY -->
```

The microVM console shares the firecracker process's stdin/stdout.

### versions

```shell
root@firecracker-1-16-1:~# firecracker --version
<!-- VERIFY -->
root@firecracker-1-16-1:~# jailer --version
<!-- VERIFY -->
root@firecracker-1-16-1:~# ls -la /opt/firecracker/
<!-- VERIFY -->
root@firecracker-1-16-1:~# uname -a
<!-- VERIFY -->
root@firecracker-1-16-1:~# cat /etc/os-release
<!-- VERIFY -->
```

## build

```shell
make all ENV=firecracker/v1.16.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/firecracker-v1.16.1:ctr_v0.1.0
```
