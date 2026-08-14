# kubernetes v1.34.0 cluster (master + worker)

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-master:latest | point to v0.1.2 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-master:v0.1.2 | runtime fixes: hosts mapping + kube-proxy configmap server |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-master:v0.1.1 | first CI-built image (v0.1.0 never published: CI healthz probe bug) |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-master:v0.1.0 | migrate from docker_archive |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:latest | point to v0.1.2 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:v0.1.2 | runtime fixes: hosts mapping + kube-proxy configmap server |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:v0.1.1 | first CI-built image (v0.1.0 never published: CI healthz probe bug) |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:v0.1.0 | migrate from docker_archive |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.34.0-master:ctr_v0.1.2 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:ctr_v0.1.2 | - |

source: `ssst0n3/docker_archive:kubernetes-v1.34.0-master_v0.1.0` / `ssst0n3/docker_archive:kubernetes-v1.34.0-worker_v0.1.0`

## usage

### Start and connect

```shell
$ cd kubernetes/v1.34.0/containerd/v2.1.4/cluster
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
```

```shell
$ kubectl --kubeconfig=kubeconfig get nodes -o wide
NAME                                 STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
kubernetes-1-34-0-containerd-2-1-4   Ready    control-plane   31d   v1.34.0   10.0.2.16     <none>        Ubuntu 24.04.4 LTS   6.8.0-137-generic   containerd://2.1.4
kubernetes-1-34-0-worker             Ready    <none>          12h   v1.34.0   10.0.2.17     <none>        Ubuntu 24.04.4 LTS   6.8.0-137-generic   containerd://2.1.4
```

Connect to master or worker:

```shell
$ ./master/ssh
$ ./worker/ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-34-0:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-799fdf64b5-5hdd9                            1/1     Running   2 (2m24s ago)   31d
calico-apiserver   calico-apiserver-799fdf64b5-sqvmv                            1/1     Running   2 (2m24s ago)   31d
calico-system      calico-kube-controllers-679897cb9c-6mkkx                     1/1     Running   2 (2m24s ago)   31d
calico-system      calico-node-m4jv2                                            1/1     Running   1 (2m16s ago)   12h
calico-system      calico-node-pjv9d                                            1/1     Running   2 (2m24s ago)   31d
calico-system      calico-typha-789987d96-l2mc8                                 1/1     Running   2 (2m24s ago)   31d
calico-system      csi-node-driver-7hk9p                                        2/2     Running   4 (2m24s ago)   31d
calico-system      csi-node-driver-f7dmf                                        2/2     Running   0               12h
calico-system      goldmane-64654bd66b-ccsr7                                    1/1     Running   2 (2m24s ago)   31d
calico-system      whisker-7f7c65ff79-jfwws                                     2/2     Running   4 (2m24s ago)   31d
kube-system        coredns-66bc5c9577-kwsw2                                     1/1     Running   2 (2m24s ago)   31d
kube-system        coredns-66bc5c9577-kzk86                                     1/1     Running   2 (2m24s ago)   31d
kube-system        etcd-kubernetes-1-34-0-containerd-2-1-4                      1/1     Running   3 (2m24s ago)   31d
kube-system        kube-apiserver-kubernetes-1-34-0-containerd-2-1-4            1/1     Running   3 (2m24s ago)   31d
kube-system        kube-controller-manager-kubernetes-1-34-0-containerd-2-1-4   1/1     Running   3 (2m24s ago)   31d
kube-system        kube-proxy-m2hb2                                             1/1     Running   1 (2m16s ago)   12h
kube-system        kube-proxy-wq5lv                                             1/1     Running   3 (2m24s ago)   31d
kube-system        kube-scheduler-kubernetes-1-34-0-containerd-2-1-4            1/1     Running   3 (2m24s ago)   31d
tigera-operator    tigera-operator-65cdcdfd6d-25768                             1/1     Running   2 (2m24s ago)   31d
```

### versions

```shell
root@kubernetes-1-34-0:~# helm version
version.BuildInfo{Version:"v3.19.0", GitCommit:"3d8990f0836691f0229297773f3524598f46bda6", GitTreeState:"clean", GoVersion:"go1.24.7"}
root@kubernetes-1-34-0:~# kubectl version
Client Version: v1.34.0
Kustomize Version: v5.7.1
Server Version: v1.34.0
root@kubernetes-1-34-0:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.4 75cb2b7193e4e490e9fbdc236c0e811ccaba3376
root@kubernetes-1-34-0:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@kubernetes-1-34-0:~# cat /etc/os-release
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
root@kubernetes-1-34-0:~# uname -a
Linux kubernetes-1-34-0-containerd-2-1-4 6.8.0-137-generic #137-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 17 20:28:23 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

CI builds the cluster automatically in a single job: the workflow collapses
`cluster/master` + `cluster/worker` into one `cluster` matrix entry, and
`script/ci_cluster.sh` coordinates the two builds (master ctr hangs until the
worker's `kubeadm join` succeeds, targeting the master sandbox at `10.0.2.16`
on the shared `docker-archive-bridge` network).

> **VERSION bump rule**: `cluster/master/.env` and `cluster/worker/.env` are
> rebuilt together in one job. Always bump both `VERSION=` lines in the same
> commit — a single-sided bump would retag only one image and break the pair.

Local coordinated build (fallback, same flow as CI):

```shell
# session 1: build master (hangs waiting for worker join)
make all ENV=kubernetes/v1.34.0/containerd/v2.1.4/cluster/master
```

wait until `[master] Waiting for at least one worker node to become Ready.` appears in `dmesg`, then in session 2:

```shell
# session 2: build worker (kubeadm join to master at 10.0.2.16)
make all ENV=kubernetes/v1.34.0/containerd/v2.1.4/cluster/worker
```

> The worker's `kubeconfig` (build input, `COPY kubeconfig /etc/kubernetes/admin.conf`)
> is extracted from the calico base image — the CA lives in that image, so this
> copy stays valid across master rebuilds.

## for developers

### master

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_calico:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

### worker

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.34.0_containerd-v2.1.4_base:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 (master) / 10.0.2.17 (worker) to debug.
