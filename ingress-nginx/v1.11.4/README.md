# ingress-nginx v1.11.4

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/ingress-nginx-v1.11.4:latest | point to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/ingress-nginx-v1.11.4:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ingress-nginx-v1.11.4_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/ingress-nginx-v1.11.4:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_ingress-nginx-v1.11.4_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up ingress-nginx/v1.11.4
$ ssh dqd-ingress-nginx-v1.11.4
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ingress-nginx/v1.11.4
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

### Access ingress-nginx

The controller Service is type `LoadBalancer`, but `EXTERNAL-IP` stays `<pending>` — the `provider/cloud` deploy manifest does not allocate a real load balancer in this single-node VM. Reach the controller through its NodePort, or via `kubectl port-forward`.

NodePorts `31298` (http) and `31170` (https) are **not** forwarded to the host (only `22` and `6443` are — see `docker-compose.yml`), so curl them from inside the VM, or use port-forward from the host.

Deploy a sample backend + Ingress:

```shell
$ cat > /tmp/echo.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: {name: echo, labels: {app: echo}}
spec:
  replicas: 1
  selector: {matchLabels: {app: echo}}
  template:
    metadata: {labels: {app: echo}}
    spec:
      containers:
      - name: echo
        image: hashicorp/http-echo:0.2.3
        args: ["-text=hello-from-ingress"]
        ports: [{containerPort: 5678}]
---
apiVersion: v1
kind: Service
metadata: {name: echo}
spec:
  selector: {app: echo}
  ports: [{port: 5678, targetPort: 5678}]
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  annotations: {nginx.ingress.kubernetes.io/rewrite-target: /}
spec:
  ingressClassName: nginx
  rules:
  - host: echo.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: {name: echo, port: {number: 5678}}
EOF
$ kubectl --kubeconfig=kubeconfig apply -f /tmp/echo.yaml
$ kubectl --kubeconfig=kubeconfig get ingress
NAME   CLASS   HOSTS        ADDRESS   PORTS   AGE
echo   nginx   echo.local             80      8s
```

From the host via port-forward (pick a free local port — `8080` is often taken):

```shell
$ kubectl --kubeconfig=kubeconfig port-forward -n ingress-nginx svc/ingress-nginx-controller 38080:80 &
$ curl -H "Host: echo.local" http://127.0.0.1:38080/
hello-from-ingress
$ curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:38080/   # no Host header → default backend
404
```

Or from inside the VM via the NodePort (`31298` http / `31170` https):

```shell
$ ssh dqd-ingress-nginx-v1.11.4
root@kubernetes-1-32-3-containerd-2-0-3:~# curl -H "Host: echo.local" http://127.0.0.1:31298/
hello-from-ingress
root@kubernetes-1-32-3-containerd-2-0-3:~# curl -k -H "Host: echo.local" https://127.0.0.1:31170/
hello-from-ingress
```

Clean up:

```shell
$ kubectl --kubeconfig=kubeconfig delete -f /tmp/echo.yaml
```

### versions

```shell
root@kubernetes-1-32-3-containerd-2-0-3:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-32-3-containerd-2-0-3:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-32-3-containerd-2-0-3:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-32-3-containerd-2-0-3:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-32-3-containerd-2-0-3:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=ingress-nginx/v1.11.4
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.32.3_containerd-v2.0.3_calico:ctr_v0.3.0
...
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
