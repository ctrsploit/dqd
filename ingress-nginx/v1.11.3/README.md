# ingress-nginx v1.11.3

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/ingress-nginx-v1.11.3:latest | point to `v0.1.7` |
| dqd | ghcr.io/ctrsploit/ingress-nginx-v1.11.3:v0.1.7 | fix build (SANDBOX_HOSTNAME + strip char-dev whiteouts) |
| dqd | ghcr.io/ctrsploit/ingress-nginx-v1.11.3:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:ingress-nginx-v1.11.3_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/ingress-nginx-v1.11.3:ctr_v0.1.7 | - |
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
NAMESPACE          NAME                                                         READY   STATUS      RESTARTS      AGE
calico-apiserver   calico-apiserver-5ff558d6df-r4nt4                            1/1     Running     2 (17m ago)   15d
calico-apiserver   calico-apiserver-5ff558d6df-xp9w2                            1/1     Running     2 (17m ago)   15d
calico-system      calico-kube-controllers-59f67db8b-hlb5g                      1/1     Running     2 (17m ago)   15d
calico-system      calico-node-bg9hn                                            1/1     Running     2 (17m ago)   15d
calico-system      calico-typha-768748bcd5-9cffj                                1/1     Running     2 (17m ago)   15d
calico-system      csi-node-driver-9ffrr                                        2/2     Running     4 (17m ago)   15d
ingress-nginx      ingress-nginx-admission-create-snwbt                         0/1     Completed   0             49m
ingress-nginx      ingress-nginx-admission-patch-8z988                          0/1     Completed   1             49m
ingress-nginx      ingress-nginx-controller-9456df685-crfxg                     1/1     Running     1 (17m ago)   49m
kube-system        coredns-668d6bf9bc-fhbx7                                     1/1     Running     2 (17m ago)   15d
kube-system        coredns-668d6bf9bc-h7sbc                                     1/1     Running     2 (17m ago)   15d
kube-system        etcd-kubernetes-1-32-3-containerd-2-0-3                      1/1     Running     3 (17m ago)   15d
kube-system        kube-apiserver-kubernetes-1-32-3-containerd-2-0-3            1/1     Running     3 (17m ago)   15d
kube-system        kube-controller-manager-kubernetes-1-32-3-containerd-2-0-3   1/1     Running     3 (17m ago)   15d
kube-system        kube-proxy-djk4g                                             1/1     Running     3 (17m ago)   15d
kube-system        kube-scheduler-kubernetes-1-32-3-containerd-2-0-3            1/1     Running     3 (17m ago)   15d
tigera-operator    tigera-operator-789496d6f5-f4r74                             1/1     Running     2 (17m ago)   15d

$ kubectl --kubeconfig=kubeconfig get services -A
NAMESPACE          NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
calico-apiserver   calico-api                           ClusterIP      10.96.34.102    <none>        443/TCP                      15d
calico-system      calico-kube-controllers-metrics      ClusterIP      None            <none>        9094/TCP                     15d
calico-system      calico-typha                         ClusterIP      10.96.214.125   <none>        5473/TCP                     15d
default            kubernetes                           ClusterIP      10.96.0.1       <none>        443/TCP                      15d
ingress-nginx      ingress-nginx-controller             LoadBalancer   10.96.97.73     <pending>     80:31298/TCP,443:31170/TCP   49m
ingress-nginx      ingress-nginx-controller-admission   ClusterIP      10.96.185.78    <none>        443/TCP                      49m
kube-system        kube-dns                             ClusterIP      10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP       15d

$ kubectl --kubeconfig=kubeconfig describe service -n ingress-nginx ingress-nginx-controller
Name:                     ingress-nginx-controller
Namespace:                ingress-nginx
Labels:                   app.kubernetes.io/component=controller
                          app.kubernetes.io/instance=ingress-nginx
                          app.kubernetes.io/name=ingress-nginx
                          app.kubernetes.io/part-of=ingress-nginx
                          app.kubernetes.io/version=1.11.3
Annotations:              <none>
Selector:                 app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.96.97.73
IPs:                      10.96.97.73
Port:                     http  80/TCP
TargetPort:               http/TCP
NodePort:                 http  31298/TCP
Endpoints:                192.168.92.16:80
Port:                     https  443/TCP
TargetPort:               https/TCP
NodePort:                 https  31170/TCP
Endpoints:                192.168.92.16:443
Session Affinity:         None
External Traffic Policy:  Local
Internal Traffic Policy:  Cluster
HealthCheck NodePort:     32399
Events:                   <none>

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
$ ssh dqd-ingress-nginx-v1.11.3
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
Linux kubernetes-1-32-3-containerd-2-0-3 6.8.0-136-generic #136-Ubuntu SMP PREEMPT_DYNAMIC Wed Jul  1 21:53:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux

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
RUN --security=insecure ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* use systemd service to execute commands.
* ssh root/root 10.0.2.16 to debug.
