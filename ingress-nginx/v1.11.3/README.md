# ingress-nginx v1.11.3

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/ingress-nginx-v1.11.3:latest | point to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/ingress-nginx-v1.11.3:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ingress-nginx-v1.11.3_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/ingress-nginx-v1.11.3:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ingress-nginx-v1.11.3_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up ingress-nginx/v1.11.3
$ ssh dqd-ingress-nginx-v1.11.3
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ingress-nginx/v1.11.3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Inspect built-in pods

```shell
$ kubectl --kubeconfig=kubeconfig get pods -A
<!-- VERIFY -->
$ kubectl --kubeconfig=kubeconfig get services -A
<!-- VERIFY -->
$ kubectl --kubeconfig=kubeconfig describe service -n ingress-nginx ingress-nginx-controller
<!-- VERIFY -->
```

### versions

```shell
root@k8s-control-plane:~# kubectl version
<!-- VERIFY -->
root@k8s-control-plane:~# containerd --version
<!-- VERIFY -->
root@k8s-control-plane:~# runc --version
<!-- VERIFY -->
root@k8s-control-plane:~# cat /etc/os-release
<!-- VERIFY -->
root@k8s-control-plane:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=ingress-nginx/v1.11.3
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.32.3_containerd-v2.0.3_calico:ctr_v0.3.0
...
RUN --security=insecure ["/sbin/init", "--log-target=kmsg"]
```

* use `dmesg -w` to see build logs.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
