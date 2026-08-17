# kubernetes v1.18.2 cluster (master + worker)

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2-master:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2-master:v0.1.0 | migrate from docker_archive |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2-worker:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.18.2-worker:v0.1.0 | migrate from docker_archive |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.18.2-master:ctr_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.18.2-worker:ctr_v0.1.0 | - |

source: `ssst0n3/docker_archive:kubernetes-v1.18.2-master_v0.1.0` / `ssst0n3/docker_archive:kubernetes-v1.18.2-worker_v0.1.0`

## usage

### Start and connect

```shell
$ cd kubernetes/v1.18.2/containerd/v1.3.3/cluster
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

```shell
$ kubectl --kubeconfig=kubeconfig get nodes -o wide
NAME                                 STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
kubernetes-1-18-2-containerd-1-3-3   Ready    master   73d   v1.18.2   10.0.2.16     <none>        Ubuntu 20.04.6 LTS   5.4.0-216-generic   containerd://1.3.3
kubernetes-1-18-2-worker             Ready    <none>   31m   v1.18.2   <none>        <none>        Ubuntu 20.04.6 LTS   5.4.0-216-generic   containerd://1.3.3
```

Connect to master or worker:

```shell
$ ./master/ssh
$ ./worker/ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-18-2:~# kubectl get pods -A
NAMESPACE         NAME                                                         READY   STATUS    RESTARTS   AGE
calico-system     calico-kube-controllers-57f767d97b-tcf62                     1/1     Running   2          19d
calico-system     calico-node-prwk8                                            1/1     Running   1          31m
calico-system     calico-node-sz4zf                                            1/1     Running   2          19d
calico-system     calico-typha-9cc6b5ffc-7b8gc                                 1/1     Running   3          19d
calico-system     calico-typha-9cc6b5ffc-dqmh4                                 1/1     Running   2          31m
kube-system       coredns-66bff467f8-ntd5z                                     1/1     Running   2          73d
kube-system       coredns-66bff467f8-rzprn                                     1/1     Running   2          73d
kube-system       etcd-kubernetes-1-18-2-containerd-1-3-3                      1/1     Running   3          73d
kube-system       kube-apiserver-kubernetes-1-18-2-containerd-1-3-3            1/1     Running   3          73d
kube-system       kube-controller-manager-kubernetes-1-18-2-containerd-1-3-3   1/1     Running   3          73d
kube-system       kube-proxy-25jcz                                             1/1     Running   3          73d
kube-system       kube-proxy-hg8wh                                             1/1     Running   1          31m
kube-system       kube-scheduler-kubernetes-1-18-2-containerd-1-3-3            1/1     Running   3          73d
tigera-operator   tigera-operator-6ddb54fbf5-pz878                             1/1     Running   3          19d
```

### versions

```shell
root@kubernetes-1-18-2:~# helm version
version.BuildInfo{Version:"v3.2.4", GitCommit:"0ad800ef43d3b826f31a5ad8dfbb4fe05d143688", GitTreeState:"clean", GoVersion:"go1.13.12"}
root@kubernetes-1-18-2:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:56:40Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:48:36Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
root@kubernetes-1-18-2:~# containerd --version
containerd github.com/containerd/containerd v1.3.3 d76c121f76a5fc8a462dc64594aea72fe18e1178
root@kubernetes-1-18-2:~# runc --version
runc version 1.0.0-rc10
spec: 1.0.1-dev
root@kubernetes-1-18-2:~# cat /etc/os-release
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
root@kubernetes-1-18-2:~# uname -a
Linux kubernetes-1-18-2-containerd-1-3-3 5.4.0-216-generic #236-Ubuntu SMP Fri Apr 11 19:53:21 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

CI builds the cluster automatically in a single job: the workflow collapses
`cluster/master` + `cluster/worker` into one `cluster` matrix entry, and
`script/ci_cluster.sh` coordinates the two builds. Because v1.18.2 (systemd 245,
Ubuntu 20.04) requires a cgroup-v1 environment, the ctr builds run inside the
`dqd/cgroup-v1-builder` VM (`CI_DQD_BUILDER` in both sub-env `.env` files), then
the vm/dqd stages run on the CI host.

> **VERSION bump rule**: `cluster/master/.env` and `cluster/worker/.env` are
> rebuilt together in one job. Always bump both `VERSION=` lines in the same
> commit — a single-sided bump would retag only one image and break the pair.

## for developers

### master

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_calico:ctr_v0.1.4
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

### worker

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.18.2_containerd-v1.3.3_base:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* systemd 245 needs `ENV container=docker` for `systemctl exit 0` and the
  `cgroup-kill.service` to avoid systemd-shutdown hangs on containerd-shim.
* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 (master) / 10.0.2.17 (worker) to debug.
