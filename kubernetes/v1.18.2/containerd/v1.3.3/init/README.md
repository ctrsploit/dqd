# Kubernetes v1.18.2 with containerd v1.3.3

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_init:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_init:v0.1.0 | migrate from docker_archive |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_init:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.18.2/containerd/v1.3.3/init
$ ssh dqd-kubernetes-v1.18.2_containerd-v1.3.3_init
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.18.2/containerd/v1.3.3/init
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### built-in pods

```shell
root@kubernetes-1-18-2-containerd-1-3-3:~# kubectl get pods -A
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS   AGE
kube-system   coredns-66bff467f8-ntd5z                                     0/1     Pending   0          15h
kube-system   coredns-66bff467f8-rzprn                                     0/1     Pending   0          15h
kube-system   etcd-kubernetes-1-18-2-containerd-1-3-3                      1/1     Running   1          15h
kube-system   kube-apiserver-kubernetes-1-18-2-containerd-1-3-3            1/1     Running   1          15h
kube-system   kube-controller-manager-kubernetes-1-18-2-containerd-1-3-3   1/1     Running   1          15h
kube-system   kube-proxy-25jcz                                             1/1     Running   1          15h
kube-system   kube-scheduler-kubernetes-1-18-2-containerd-1-3-3            1/1     Running   1          15h
```

### versions

```shell
root@kubernetes-1-18-2-containerd-1-3-3:~# helm version
version.BuildInfo{Version:"v3.2.4", GitCommit:"0ad800ef43d3b826f31a5ad8dfbb4fe05d143688", GitTreeState:"clean", GoVersion:"go1.13.12"}
root@kubernetes-1-18-2-containerd-1-3-3:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:56:40Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:48:36Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
root@kubernetes-1-18-2-containerd-1-3-3:~# containerd --version
containerd github.com/containerd/containerd v1.3.3 d76c121f76a5fc8a462dc64594aea72fe18e1178
root@kubernetes-1-18-2-containerd-1-3-3:~# runc --version
runc version 1.0.0-rc10
spec: 1.0.1-dev
root@kubernetes-1-18-2-containerd-1-3-3:~# cat /etc/os-release
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
root@kubernetes-1-18-2-containerd-1-3-3:~# uname -a
Linux kubernetes-1-18-2-containerd-1-3-3 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.18.2/containerd/v1.3.3/init
```

GitHub Actions builds the `ctr` image with `CI_DQD_BUILDER=dqd/cgroup-v1-builder` because Kubernetes v1.18.2 kubelet requires cgroup v1 during `kubeadm init`.

for developers:

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_init:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

## Tricks

### cgroup v1

Kubernetes v1.18.2 kubelet only supports cgroup v1. On GitHub-hosted runners, this env declares `CI_DQD_BUILDER=dqd/cgroup-v1-builder`, so CI starts that dqd runtime and runs the `ctr` build there before continuing the VM and DQD image build on the host runner.

### cache mount

This build uses a BuildKit cache mount for containerd snapshots so kubeadm writes under an ext4-backed cache instead of overlayfs-on-overlayfs.
