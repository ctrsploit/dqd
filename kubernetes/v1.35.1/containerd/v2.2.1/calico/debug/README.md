# Kubernetes v1.35.1 with Containerd v2.2.1 (Calico, Debug)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.1_containerd-v2.2.1_calico_debug:latest | -> `v0.2.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.1_containerd-v2.2.1_calico_debug:v0.2.0 | debug kubelet,containerd |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.35.1_containerd-v2.2.1_calico_debug:v0.1.0 | debug kubelet |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.35.1_containerd-v2.2.1_calico_debug:ctr_v0.2.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.35.1_containerd-v2.2.1_calico_debug:ctr_v0.1.0 | - |

## Usage

### Startup

```shell
$ cd kubernetes/v1.35.1/containerd/v2.2.1/calico/debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

### Debug Kubelet with Delve

```shell
$ ./ssh
root@kubernetes-1-35-1-containerd-2-2-1:~# systemctl stop kubelet
root@kubernetes-1-35-1-containerd-2-2-1:~# ln -sf /usr/local/bin/debug.sh /usr/bin/kubelet
root@kubernetes-1-35-1-containerd-2-2-1:~# systemctl start kubelet
root@kubernetes-1-35-1-containerd-2-2-1:~# journalctl -u kubelet -f
API server listening at: [::]:2345
...
```

### Debug Containerd with Delve

```shell
$ ./ssh
root@kubernetes-1-35-1-containerd-2-2-1:~# systemctl stop containerd
root@kubernetes-1-35-1-containerd-2-2-1:~# ln -sf /usr/local/bin/debug.sh /usr/local/bin/containerd
root@kubernetes-1-35-1-containerd-2-2-1:~# /usr/local/bin/containerd --config /etc/containerd/config.toml
API server listening at: [::]:2346
...
```

> Using `systemctl start containerd` is also ok, but will raise a systemctl's timeout error. It's as an expected behavior, because `containerd.service` uses `Type=notify`, and launching containerd via Delve can cause systemd startup timeout.

### GoLand remote attach

kubelet

```text
Run/Debug Configurations -> Go Remote
Host: 127.0.0.1
Port: 13516
```

containerd

```text
Run/Debug Configurations -> Go Remote
Host: 127.0.0.1
Port: 13517
```

### Restore Kubelet

```shell
root@kubernetes-1-35-1-containerd-2-2-1:~# systemctl stop kubelet
root@kubernetes-1-35-1-containerd-2-2-1:~# cp /usr/local/bin/kubelet.real /usr/bin/kubelet
root@kubernetes-1-35-1-containerd-2-2-1:~# chmod +x /usr/bin/kubelet
root@kubernetes-1-35-1-containerd-2-2-1:~# systemctl start kubelet
```

### Restore Containerd

```shell
root@kubernetes-1-35-1-containerd-2-2-1:~# systemctl stop containerd
root@kubernetes-1-35-1-containerd-2-2-1:~# cp /usr/local/bin/containerd.real /usr/local/bin/containerd
root@kubernetes-1-35-1-containerd-2-2-1:~# chmod +x /usr/local/bin/containerd
root@kubernetes-1-35-1-containerd-2-2-1:~# systemctl start containerd
```

### Built-in Pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS       AGE
calico-system     calico-apiserver-cd88f9f5f-dnlxv                             1/1     Running   0              18h
calico-system     calico-apiserver-cd88f9f5f-p5dt9                             1/1     Running   0              18h
calico-system     calico-kube-controllers-57f889fd64-gbf6h                     1/1     Running   0              18h
calico-system     calico-node-gfhsl                                            1/1     Running   0              18h
calico-system     calico-typha-7f959dd765-7pzj5                                1/1     Running   1 (2m4s ago)   18h
calico-system     goldmane-58f96f7c58-fwfjc                                    1/1     Running   0              18h
calico-system     whisker-747d65498f-cx6wb                                     2/2     Running   0              21s
kube-system       coredns-7d764666f9-4pdss                                     1/1     Running   0              19h
kube-system       coredns-7d764666f9-msknr                                     1/1     Running   0              19h
kube-system       etcd-kubernetes-1-35-1-containerd-2-2-1                      1/1     Running   2 (2m4s ago)   19h
kube-system       kube-apiserver-kubernetes-1-35-1-containerd-2-2-1            1/1     Running   2 (2m4s ago)   19h
kube-system       kube-controller-manager-kubernetes-1-35-1-containerd-2-2-1   1/1     Running   2 (2m4s ago)   19h
kube-system       kube-proxy-9r6g8                                             1/1     Running   2 (2m4s ago)   19h
kube-system       kube-scheduler-kubernetes-1-35-1-containerd-2-2-1            1/1     Running   2 (2m4s ago)   19h
tigera-operator   tigera-operator-6cf4cccc57-x4p56                             1/1     Running   1 (2m4s ago)   18h
```

### Deploy a Pod

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
pod/nginx created
$ kubectl --kubeconfig=kubeconfig get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          39s
```

### Versions

```shell
$ ./ssh
root@kubernetes-1-35-1-containerd-2-2-1:~# helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-35-1-containerd-2-2-1:~# kubectl version
Client Version: v1.35.1
Kustomize Version: v5.7.1
Server Version: v1.35.1
root@kubernetes-1-35-1-containerd-2-2-1:~# nerdctl --version
nerdctl version 2.2.1
root@kubernetes-1-35-1-containerd-2-2-1:~# buildkitd --version
buildkitd github.com/moby/buildkit v0.26.3 c70e8e666f8f6ee3c0d83b20c338be5aedeaa97a
root@kubernetes-1-35-1-containerd-2-2-1:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.2.1 dea7da592f5d1d2b7755e3a161be07f43fad8f75
root@kubernetes-1-35-1-containerd-2-2-1:~# runc --version
runc version 1.3.4
commit: v1.3.4-0-gd6d73eb8
spec: 1.2.1
go: go1.24.10
libseccomp: 2.5.6
root@kubernetes-1-35-1-containerd-2-2-1:~# cat /etc/os-release
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
root@kubernetes-1-35-1-containerd-2-2-1:~# uname -a
Linux kubernetes-1-35-1-containerd-2-2-1 6.8.0-101-generic #101-Ubuntu SMP PREEMPT_DYNAMIC Mon Feb  9 10:15:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## Build

```shell
make all ENV=kubernetes/v1.35.1/containerd/v2.2.1/calico/debug
```

### For Developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.35.1_containerd-v2.2.1_calico_debug:ctr_v0.2.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
