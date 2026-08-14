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
<!-- VERIFY -->
```

Connect to master or worker:

```shell
$ ./master/ssh
$ ./worker/ssh
```

### Inspect built-in pods

```shell
root@kubernetes-1-18-2:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-18-2:~# helm version
<!-- VERIFY -->
root@kubernetes-1-18-2:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-18-2:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-18-2:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-18-2:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-18-2:~# uname -a
<!-- VERIFY -->
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
