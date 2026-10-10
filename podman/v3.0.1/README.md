# podman v3.0.1

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/podman-v3.0.1:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/podman-v3.0.1:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/podman-v3.0.1:ctr_v0.1.0 | podman 3.0.1 stack from Debian bullseye on Ubuntu 20.04 |

## usage

### Start and connect

Recommended:

```shell
$ dqd up podman/v3.0.1
$ ssh dqd-podman-v3.0.1
```

Fallback without dqd CLI or SSH config:

```shell
$ cd podman/v3.0.1
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with podman

```shell
root@podman-3-0-1:~# podman run hello-world
Resolved "hello-world" as an alias (/etc/containers/registries.conf.d/shortnames.conf)
Trying to pull docker.io/library/hello-world:latest...
Getting image source signatures
Copying blob sha256:4f55086f7dd096d48b0e49be066971a8ed996521c2e190aa21b2435a847198b4
Copying config sha256:e2ac70e7319a02c5a477f5825259bd118b94e8b02c279c67afa63adab6d8685b
Writing manifest to image destination
Storing signatures

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed the output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### versions

```shell
root@podman-3-0-1:~# podman version
Version:      3.0.1
API Version:  3.0.0
Go Version:   go1.15.15
Built:        Thu Jan  1 00:00:00 1970
OS/Arch:      linux/amd64
root@podman-3-0-1:~# crun --version
crun version 0.17
commit: 0e9229ae34caaebcb86f1fde18de3acaf18c6d9a
spec: 1.0.0
+SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +YAJL
root@podman-3-0-1:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.6 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.6 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
root@podman-3-0-1:~# uname -a
Linux podman-3-0-1 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=podman/v3.0.1
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/podman-v3.0.1:ctr_v0.1.0
```
