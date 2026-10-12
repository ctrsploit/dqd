# cri-o v1.20.9

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/cri-o-v1.20.9:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/cri-o-v1.20.9:v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/cri-o-v1.20.9:ctr_v0.1.0 | cri-o official static bundle on Ubuntu 20.04 |

## usage

### Start and connect

Recommended:

```shell
$ dqd up cri-o/v1.20.9
$ ssh dqd-cri-o-v1.20.9
```

Fallback without dqd CLI or SSH config:

```shell
$ cd cri-o/v1.20.9
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a container

```shell
root@cri-o-1-20-9:~# crictl pull docker.io/library/busybox
Image is up to date for docker.io/library/busybox@sha256:f97baa533a26513c453a362be331a43eb60214302f449c16571b23cea141dce4
root@cri-o-1-20-9:~# crictl runp /root/pod.json
f0258938dbe973ecf88878869bd26969dddd367ce1331566297fa250a958b9e7
root@cri-o-1-20-9:~# crictl create $(crictl pods -q) /root/container.json /root/pod.json
60e37e8f3e3b228908d9423fff646cb35e1ed15865bdc857057c75d3b256feb5
root@cri-o-1-20-9:~# crictl start $(crictl ps -q --state created)
60e37e8f3e3b228908d9423fff646cb35e1ed15865bdc857057c75d3b256feb5
root@cri-o-1-20-9:~# crictl ps
CONTAINER           IMAGE                              CREATED                  STATE               NAME                ATTEMPT             POD ID
60e37e8f3e3b2       docker.io/library/busybox:latest   Less than a second ago   Running             crio-demo           0                   f0258938dbe97
```

### versions

```shell
root@cri-o-1-20-9:~# crio --version
crio version 1.20.9
Version:       1.20.9
GitCommit:     9a866fd3365c4fc687c0c31ecb0fe356cd1e23fe
GitTreeState:  dirty
BuildDate:     1980-01-01T00:00:00Z
GoVersion:     go1.15.7
Compiler:      gc
Platform:      linux/amd64
Linkmode:      static
root@cri-o-1-20-9:~# runc --version
runc version 1.0.0-rc92
spec: 1.0.2-dev
root@cri-o-1-20-9:~# cat /etc/os-release
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
root@cri-o-1-20-9:~# uname -a
Linux cri-o-1-20-9 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=cri-o/v1.20.9
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/cri-o-v1.20.9:ctr_v0.1.0
```
