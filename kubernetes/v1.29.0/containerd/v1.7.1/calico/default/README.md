# Kubernetes v1.29.0 with containerd v1.7.1, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.29.0_containerd-v1.7.1_calico:latest | -> v0.1.1 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.29.0_containerd-v1.7.1_calico:v0.1.1 | FROM init ctr_v0.1.1 (xattrs fix); add --xattrs --xattrs-include='*' to snapshot-restore tar |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.29.0_containerd-v1.7.1_calico:v0.1.0 | migrate from docker_archive (FROM init ctr_v0.1.0, coredns CrashLoopBackOff: CAP_NET_BIND_SERVICE stripped) |
| dqd | ssst0n3/docker_archive:kubernetes-v1.29.0-calico_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.29.0_containerd-v1.7.1_calico:ctr_v0.1.1 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.29.0_containerd-v1.7.1_calico:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.29.0-calico_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.29.0/containerd/v1.7.1/calico/default
$ ssh dqd-kubernetes-v1.29.0_containerd-v1.7.1_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.29.0/containerd/v1.7.1/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-29-0-containerd-1-7-1:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-66fbc88969-btdwk                            1/1     Running   1 (10m ago)     11h
calico-apiserver   calico-apiserver-66fbc88969-xlr8z                            1/1     Running   1 (11h ago)     11h
calico-system      calico-kube-controllers-6dc6547b65-zsnfl                     1/1     Running   1               11h
calico-system      calico-node-pjpkb                                            1/1     Running   1 (10m ago)     11h
calico-system      calico-typha-755754d7c5-b4fhd                                1/1     Running   1 (11h ago)     11h
calico-system      csi-node-driver-89kvp                                        2/2     Running   2 (10m ago)     11h
kube-system        coredns-76f75df574-kj27z                                     1/1     Running   1 (11h ago)     25h
kube-system        coredns-76f75df574-lgm2v                                     1/1     Running   1 (11h ago)     25h
kube-system        etcd-kubernetes-1-29-0-containerd-1-7-1                      1/1     Running   2 (11h ago)     25h
kube-system        kube-apiserver-kubernetes-1-29-0-containerd-1-7-1            1/1     Running   2 (11h ago)     25h
kube-system        kube-controller-manager-kubernetes-1-29-0-containerd-1-7-1   1/1     Running   2 (10m ago)     25h
kube-system        kube-proxy-9r7tv                                             1/1     Running   2 (11h ago)     25h
kube-system        kube-scheduler-kubernetes-1-29-0-containerd-1-7-1            1/1     Running   2 (11h ago)     25h
tigera-operator    tigera-operator-79f59b7cb7-4mf4m                             1/1     Running   2 (8m53s ago)   11h
```

### versions

```shell
root@kubernetes-1-29-0-containerd-1-7-1:~# helm version
version.BuildInfo{Version:"v3.14.0", GitCommit:"3fc9f4b2638e76f26739cd77c7017139be81d0ea", GitTreeState:"clean", GoVersion:"go1.21.5"}
root@kubernetes-1-29-0-containerd-1-7-1:~# kubectl version
Client Version: v1.29.0
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.29.0
root@kubernetes-1-29-0-containerd-1-7-1:~# containerd --version
containerd github.com/containerd/containerd v1.7.1 1677a17964311325ed1c31e2c0a3589ce6d5c30d
root@kubernetes-1-29-0-containerd-1-7-1:~# runc --version
runc version 1.1.7
commit: v1.1.7-0-g860f061b
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
root@kubernetes-1-29-0-containerd-1-7-1:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@kubernetes-1-29-0-containerd-1-7-1:~# uname -a
Linux kubernetes-1-29-0-containerd-1-7-1 5.15.0-187-generic #197-Ubuntu SMP Fri Jul 17 19:17:01 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.29.0/containerd/v1.7.1/calico/default
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.29.0_containerd-v1.7.1_init:ctr_v0.1.1
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.

## Tricks

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so the calico install writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
