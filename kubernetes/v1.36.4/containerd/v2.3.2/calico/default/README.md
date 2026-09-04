# kubernetes v1.36.4 with containerd v2.3.2, calico

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:v0.1.0 | calico v3.32.2, CRDs from crd.projectcalico.org.v1 applied before tigera-operator |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:ctr_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.36.4/containerd/v2.3.2/calico/default
$ ssh dqd-kubernetes-v1.36.4_containerd-v2.3.2_calico
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.36.4/containerd/v2.3.2/calico/default
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Deploy a pod

```shell
$ kubectl --kubeconfig=kubeconfig run --image=docker.io/library/nginx:latest nginx
<!-- VERIFY -->
$ kubectl --kubeconfig=kubeconfig get pods
<!-- VERIFY -->
```

### built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-36-4-containerd-2-3-2:~# helm version
<!-- VERIFY -->
root@kubernetes-1-36-4-containerd-2-3-2:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-36-4-containerd-2-3-2:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-36-4-containerd-2-3-2:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-36-4-containerd-2-3-2:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-36-4-containerd-2-3-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=kubernetes/v1.36.4/containerd/v2.3.2/calico/default
```


## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.36.4_containerd-v2.3.2_calico:ctr_v0.1.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
