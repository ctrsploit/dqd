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
root@firecracker-1-16-1:~# cat > boot-source.json <<'EOF'
{
  "kernel_image_path": "/opt/firecracker/vmlinux-6.1.102",
  "boot_args": "console=ttyS0 reboot=k panic=1 pci=off root=/dev/vda rw"
}
EOF
root@firecracker-1-16-1:~# cat > drive-rootfs.json <<'EOF'
{
  "drive_id": "rootfs",
  "path_on_host": "/opt/firecracker/ubuntu-22.04.ext4",
  "is_root_device": true,
  "is_read_only": false
}
EOF
root@firecracker-1-16-1:~# firecracker --api-sock /tmp/fc.sock &
root@firecracker-1-16-1:~# curl -s -o /dev/null -w "%{http_code}\n" --unix-socket /tmp/fc.sock -X PUT \
    'localhost/boot-source' -H 'Content-Type: application/json' \
    --data-binary @boot-source.json
204
root@firecracker-1-16-1:~# curl -s -o /dev/null -w "%{http_code}\n" --unix-socket /tmp/fc.sock -X PUT \
    'localhost/drives/rootfs' -H 'Content-Type: application/json' \
    --data-binary @drive-rootfs.json
204
root@firecracker-1-16-1:~# curl -s -o /dev/null -w "%{http_code}\n" --unix-socket /tmp/fc.sock -X PUT \
    'localhost/actions' -H 'Content-Type: application/json' \
    -d '{"action_type": "InstanceStart"}'
204
```

The microVM console shares the firecracker process's stdin/stdout.

### versions

```shell
root@firecracker-1-16-1:~# firecracker --version
Firecracker v1.16.1

2026-11-23T07:07:59.625789569 [anonymous-instance:main] Firecracker exiting successfully. exit_code=0
root@firecracker-1-16-1:~# jailer --version
Jailer v1.16.1

root@firecracker-1-16-1:~# ls -la /opt/firecracker/
total 347032
drwxr-xr-x 2 root root      4096 Nov 23 06:53 .
drwxr-xr-x 3 root root      4096 Nov 23 06:53 ..
-r--r--r-- 1 root root 314572800 Nov 23 06:53 ubuntu-22.04.ext4
-rw------- 1 root root      2602 Nov 23 06:53 ubuntu-22.04.id_rsa
-r--r--r-- 1 root root  40774472 Nov 23 06:53 vmlinux-6.1.102
root@firecracker-1-16-1:~# uname -a
Linux firecracker-1-16-1 6.8.0-151-generic #151-Ubuntu SMP PREEMPT_DYNAMIC Wed Nov 11 01:28:36 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
root@firecracker-1-16-1:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
```

## build

```shell
make all ENV=firecracker/v1.16.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/firecracker-v1.16.1:ctr_v0.1.0
```
