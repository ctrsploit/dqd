# kubernetes v1.34.0 cluster (master + worker)

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-master:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-master:v0.1.0 | migrate from docker_archive |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:v0.1.0 | migrate from docker_archive |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.34.0-master:ctr_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:ctr_v0.1.0 | - |

source: `ssst0n3/docker_archive:kubernetes-v1.34.0-master_v0.1.0` / `ssst0n3/docker_archive:kubernetes-v1.34.0-worker_v0.1.0`

## usage

### Start and connect

```shell
$ cd kubernetes/v1.34.0/containerd/v2.1.4/cluster
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
root@kubernetes-1-34-0:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-34-0:~# helm version
<!-- VERIFY -->
root@kubernetes-1-34-0:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-34-0:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-34-0:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-34-0:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-34-0:~# uname -a
<!-- VERIFY -->
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
