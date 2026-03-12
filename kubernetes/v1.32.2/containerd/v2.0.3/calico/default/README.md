# kubernetes v1.32.2 with containerd v2.0.3, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_calico:latest | point to v0.2.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_calico:v0.2.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.32.2_containerd-v2.0.3-calico_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_calico:ctr_v0.2.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.32.2_containerd-v2.0.3_v0.1.0 | - |

## usage

```shell
$ cd kubernetes/v1.32.2/containerd/v2.0.3/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS      AGE
calico-apiserver   calico-apiserver-645d944c-h5vwp                              1/1     Running   1 (19m ago)   35m
calico-apiserver   calico-apiserver-645d944c-pmkz5                              1/1     Running   1 (19m ago)   35m
calico-system      calico-kube-controllers-768df9fb5b-rdxz9                     1/1     Running   1 (19m ago)   35m
calico-system      calico-node-mpxrh                                            1/1     Running   1 (19m ago)   35m
calico-system      calico-typha-5cdbb9c77b-66pst                                1/1     Running   1 (19m ago)   35m
calico-system      csi-node-driver-zbg74                                        2/2     Running   2 (19m ago)   35m
kube-system        coredns-668d6bf9bc-79d4n                                     1/1     Running   1 (19m ago)   65m
kube-system        coredns-668d6bf9bc-tm9p5                                     1/1     Running   1 (19m ago)   65m
kube-system        etcd-kubernetes-1-32-2-containerd-2-0-3                      1/1     Running   2 (19m ago)   65m
kube-system        kube-apiserver-kubernetes-1-32-2-containerd-2-0-3            1/1     Running   2 (19m ago)   65m
kube-system        kube-controller-manager-kubernetes-1-32-2-containerd-2-0-3   1/1     Running   2 (19m ago)   65m
kube-system        kube-proxy-wjpdj                                             1/1     Running   2 (19m ago)   65m
kube-system        kube-scheduler-kubernetes-1-32-2-containerd-2-0-3            1/1     Running   2 (19m ago)   65m
tigera-operator    tigera-operator-d77bd6f45-nhf92                              1/1     Running   1 (19m ago)   35m
```

### run a container

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
pod/nginx created
$ kubectl --kubeconfig=kubeconfig get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          39s
```

### versions

```shell
$ ./ssh
root@kubernetes-1-32-2-containerd-2-0-3:~# helm version
version.BuildInfo{Version:"v3.16.4", GitCommit:"7877b45b63f95635153b29a42c0c2f4273ec45ca", GitTreeState:"clean", GoVersion:"go1.22.7"}
root@kubernetes-1-32-2-containerd-2-0-3:~# kubectl version
Client Version: v1.32.2
Kustomize Version: v5.5.0
Server Version: v1.32.2
root@kubernetes-1-32-2-containerd-2-0-3:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.0.3 06b99ca80cdbfbc6cc8bd567021738c9af2b36ce
root@kubernetes-1-32-2-containerd-2-0-3:~# runc --version
runc version 1.2.5
commit: v1.2.5-0-g59923ef1
spec: 1.2.0
go: go1.22.12
libseccomp: 2.5.5
root@kubernetes-1-32-2-containerd-2-0-3:~# cat /etc/os-release
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
root@kubernetes-1-32-2-containerd-2-0-3:~# uname -a
Linux kubernetes-1-32-2-containerd-2-0-3 6.8.0-101-generic #101-Ubuntu SMP PREEMPT_DYNAMIC Mon Feb  9 10:15:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.32.2/containerd/v2.0.3/calico/default
```


### for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.32.2_containerd-v2.0.3_calico:ctr_v0.2.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
