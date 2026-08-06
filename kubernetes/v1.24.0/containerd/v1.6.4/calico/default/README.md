# Kubernetes v1.24.0 with containerd v1.6.4, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.24.0_containerd-v1.6.4_calico:latest | -> v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.24.0_containerd-v1.6.4_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.24.0-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.24.0_containerd-v1.6.4_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.24.0-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.24.0/containerd/v1.6.4/calico/default
$ ssh dqd-kubernetes-v1.24.0_containerd-v1.6.4_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.24.0/containerd/v1.6.4/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-24-0-containerd-1-6-4:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-6bc6db6d4b-bq4jw                            1/1     Running   1 (4m23s ago)   50m
calico-apiserver   calico-apiserver-6bc6db6d4b-q5t8m                            1/1     Running   1 (4m23s ago)   50m
calico-system      calico-kube-controllers-7cd8b89887-r6ldg                     1/1     Running   1 (4m23s ago)   51m
calico-system      calico-node-z9w2j                                            1/1     Running   1 (4m23s ago)   51m
calico-system      calico-typha-5b68fcfc47-cxq69                                1/1     Running   1 (4m23s ago)   51m
calico-system      csi-node-driver-p5z74                                        2/2     Running   2 (4m23s ago)   51m
kube-system        coredns-6d4b75cb6d-4qj9n                                     1/1     Running   1 (4m23s ago)   18h
kube-system        coredns-6d4b75cb6d-k277c                                     1/1     Running   1 (4m23s ago)   18h
kube-system        etcd-kubernetes-1-24-0-containerd-1-6-4                      1/1     Running   2 (4m23s ago)   18h
kube-system        kube-apiserver-kubernetes-1-24-0-containerd-1-6-4            1/1     Running   2 (4m23s ago)   18h
kube-system        kube-controller-manager-kubernetes-1-24-0-containerd-1-6-4   1/1     Running   2 (4m23s ago)   18h
kube-system        kube-proxy-gbd29                                             1/1     Running   2 (4m23s ago)   18h
kube-system        kube-scheduler-kubernetes-1-24-0-containerd-1-6-4            1/1     Running   2 (4m23s ago)   18h
tigera-operator    tigera-operator-6c49dc8ddf-n9wmn                             1/1     Running   2 (3m37s ago)   51m
```

### versions

```shell
root@kubernetes-1-24-0-containerd-1-6-4:~# helm version
version.BuildInfo{Version:"v3.9.0", GitCommit:"7ceeda6c585217a19a1131663d8cd1f7d641b2a7", GitTreeState:"clean", GoVersion:"go1.17.5"}
root@kubernetes-1-24-0-containerd-1-6-4:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.0", GitCommit:"4ce5a8954017644c5420bae81d72b09b735c21f0", GitTreeState:"clean", BuildDate:"2022-05-03T13:46:05Z", GoVersion:"go1.18.1", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.4
Server Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.0", GitCommit:"4ce5a8954017644c5420bae81d72b09b735c21f0", GitTreeState:"clean", BuildDate:"2022-05-03T13:38:19Z", GoVersion:"go1.18.1", Compiler:"gc", Platform:"linux/amd64"}
root@kubernetes-1-24-0-containerd-1-6-4:~# containerd --version
containerd github.com/containerd/containerd v1.6.4 212e8b6fa2f44b9c21b2798135fc6fb7c53efc16
root@kubernetes-1-24-0-containerd-1-6-4:~# runc --version
runc version 1.0.0-rc95
spec: 1.0.2-dev
go: go1.14.15
libseccomp: 2.5.1
root@kubernetes-1-24-0-containerd-1-6-4:~# cat /etc/os-release
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
root@kubernetes-1-24-0-containerd-1-6-4:~# uname -a
Linux kubernetes-1-24-0-containerd-1-6-4 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.24.0/containerd/v1.6.4/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.24.0_containerd-v1.6.4_init:ctr_v0.1.1
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
