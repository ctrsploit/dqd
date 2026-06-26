# nerdctl v0.5.0

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/nerdctl-v0.5.0:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/nerdctl-v0.5.0:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:nerdctl-v0.5.0_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/nerdctl-v0.5.0:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_nerdctl-v0.5.0_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up nerdctl/v0.5.0
$ ssh dqd-nerdctl-v0.5.0
```

Fallback without dqd CLI or SSH config:

```shell
$ cd nerdctl/v0.5.0
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container with nerdctl

```shell
root@nerdctl-0-5-0:~# nerdctl run hello-world

Hello from Docker!
...
root@nerdctl-0-5-0:~# echo 'FROM hello-world' > Dockerfile
root@nerdctl-0-5-0:~# nerdctl build -t foo .
root@nerdctl-0-5-0:~# nerdctl images
REPOSITORY          TAG                                                                 IMAGE ID        CREATED           SIZE
foo                 latest                                                              69f77b606f50    8 seconds ago     3.4 KiB
hello-world         latest                                                              dd01f97f2521    26 seconds ago    16.3 KiB
overlayfs@sha256    69f77b606f50e9916d51c37132f4351a2d8d31dc0d95b95dce68a4cf6ba4ace1    69f77b606f50    8 seconds ago     3.4 KiB
```

### versions

```shell
root@nerdctl-0-5-0:~# nerdctl --version
nerdctl version 0.5.0
root@nerdctl-0-5-0:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.8.1 8142d66b5ebde79846b869fba30d9d30633e74aa
root@nerdctl-0-5-0:~# containerd --version
containerd github.com/containerd/containerd v1.4.3 269548fa27e0089a8b8278fc4fc781d7f65a939b
root@nerdctl-0-5-0:~# runc --version
runc version 1.0.0-rc92
spec: 1.0.2-dev
root@nerdctl-0-5-0:~# cat /etc/os-release
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
root@nerdctl-0-5-0:~# uname -a
Linux nerdctl-0-5-0 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=nerdctl/v0.5.0
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/nerdctl-v0.5.0:ctr_v0.1.0
```
