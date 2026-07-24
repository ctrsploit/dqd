# kubernetes v1.32.3 with containerd v2.0.3, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.3_containerd-v2.0.3_calico:latest | point to v0.3.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.3_containerd-v2.0.3_calico:v0.3.0 | restore official Calico install with fail-fast init |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.3_containerd-v2.0.3_calico:v0.2.0 | fail fast when Calico install fails |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.3_containerd-v2.0.3_calico:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.32.3-calico_v0.2.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.32.3_containerd-v2.0.3_calico:ctr_v0.3.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.32.3-calico_v0.2.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.32.3/containerd/v2.0.3/calico/default
$ ssh dqd-kubernetes-v1.32.3_containerd-v2.0.3_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.32.3/containerd/v2.0.3/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-32-3-containerd-2-0-3:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-5ff558d6df-r4nt4                            1/1     Running   1 (2m41s ago)   28m
calico-apiserver   calico-apiserver-5ff558d6df-xp9w2                            1/1     Running   1 (2m41s ago)   28m
calico-system      calico-kube-controllers-59f67db8b-hlb5g                      1/1     Running   1 (2m41s ago)   28m
calico-system      calico-node-bg9hn                                            1/1     Running   1 (2m41s ago)   28m
calico-system      calico-typha-768748bcd5-9cffj                                1/1     Running   1 (2m41s ago)   28m
calico-system      csi-node-driver-9ffrr                                        2/2     Running   2 (2m41s ago)   28m
kube-system        coredns-668d6bf9bc-fhbx7                                     1/1     Running   1 (2m41s ago)   16h
kube-system        coredns-668d6bf9bc-h7sbc                                     1/1     Running   1 (2m41s ago)   16h
kube-system        etcd-kubernetes-1-32-3-containerd-2-0-3                      1/1     Running   2 (2m41s ago)   16h
kube-system        kube-apiserver-kubernetes-1-32-3-containerd-2-0-3            1/1     Running   2 (2m41s ago)   16h
kube-system        kube-controller-manager-kubernetes-1-32-3-containerd-2-0-3   1/1     Running   2 (2m41s ago)   16h
kube-system        kube-proxy-djk4g                                             1/1     Running   2 (2m41s ago)   16h
kube-system        kube-scheduler-kubernetes-1-32-3-containerd-2-0-3            1/1     Running   2 (2m41s ago)   16h
tigera-operator    tigera-operator-789496d6f5-f4r74                             1/1     Running   1 (2m41s ago)   28m
```

### Deploy a pod

```shell
root@kubernetes-1-32-3-containerd-2-0-3:~# kubectl run --image=docker.io/library/nginx:latest nginx
pod/nginx created
root@kubernetes-1-32-3-containerd-2-0-3:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          18s
```

### versions

```shell
root@kubernetes-1-32-3-containerd-2-0-3:~# helm version
version.BuildInfo{Version:"v3.16.4", GitCommit:"7877b45b63f95635153b29a42c0c2f4273ec45ca", GitTreeState:"clean", GoVersion:"go1.22.7"}
root@kubernetes-1-32-3-containerd-2-0-3:~# kubectl version
Client Version: v1.32.3
Kustomize Version: v5.5.0
Server Version: v1.32.3
root@kubernetes-1-32-3-containerd-2-0-3:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.3 06b99ca80cdbfbc6cc8bd567021738c9af2b36ce
root@kubernetes-1-32-3-containerd-2-0-3:~# runc --version
runc version 1.2.5
commit: v1.2.5-0-g59923ef1
spec: 1.2.0
go: go1.22.12
libseccomp: 2.5.5
root@kubernetes-1-32-3-containerd-2-0-3:~# cat /etc/os-release
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
root@kubernetes-1-32-3-containerd-2-0-3:~# uname -a
Linux kubernetes-1-32-3-containerd-2-0-3 6.8.0-134-generic #134-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 26 18:43:11 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.32.3/containerd/v2.0.3/calico/default
```


### for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.32.3_containerd-v2.0.3_calico:ctr_v0.3.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
