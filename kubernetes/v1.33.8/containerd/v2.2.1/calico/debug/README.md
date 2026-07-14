# Kubernetes v1.33.8 with Containerd v2.2.1 (Calico, Debug)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico_debug:latest | -> `v0.1.0` |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico_debug:v0.1.0 | debug kubelet,containerd |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico_debug:ctr_v0.1.0 | - |

## Usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.8/containerd/v2.2.1/calico/debug
$ ssh dqd-kubernetes-v1.33.8_containerd-v2.2.1_calico_debug
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.8/containerd/v2.2.1/calico/debug
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Debug Kubelet with Delve

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl stop kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# ln -sf /usr/local/bin/debug.sh /usr/bin/kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl start kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# journalctl -u kubelet -f
API server listening at: [::]:2345
...
```

### Debug Containerd with Delve

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl stop containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# ln -sf /usr/local/bin/debug.sh /usr/local/bin/containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# /usr/local/bin/containerd --config /etc/containerd/config.toml
API server listening at: [::]:2346
...
```

> Using `systemctl start containerd` is also ok, but will raise a systemctl's timeout error. It's as an expected behavior, because `containerd.service` uses `Type=notify`, and launching containerd via Delve can cause systemd startup timeout.

### GoLand remote attach

kubelet

```text
Run/Debug Configurations -> Go Remote
Host: 127.0.0.1
Port: 13386
```

containerd

```text
Run/Debug Configurations -> Go Remote
Host: 127.0.0.1
Port: 13387
```

### Restore Kubelet

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl stop kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# cp /usr/local/bin/kubelet.real /usr/bin/kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# chmod +x /usr/bin/kubelet
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl start kubelet
```

### Restore Containerd

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl stop containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# cp /usr/local/bin/containerd.real /usr/local/bin/containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# chmod +x /usr/local/bin/containerd
root@kubernetes-1-33-8-containerd-2-2-1:~# systemctl start containerd
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl get pods -A
<!-- VERIFY -->
```

### Deploy a pod

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl run --image=docker.io/library/nginx:latest nginx
<!-- VERIFY -->
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl get pods
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-33-8-containerd-2-2-1:~# helm version
<!-- VERIFY -->
root@kubernetes-1-33-8-containerd-2-2-1:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-33-8-containerd-2-2-1:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-33-8-containerd-2-2-1:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-33-8-containerd-2-2-1:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-33-8-containerd-2-2-1:~# uname -a
<!-- VERIFY -->
```

## Build

```shell
make all ENV=kubernetes/v1.33.8/containerd/v2.2.1/calico/debug
```

### For Developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.8_containerd-v2.2.1_calico_debug:ctr_v0.1.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands
* ssh root/root 10.0.2.16 to debug
