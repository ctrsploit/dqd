# kubernetes v1.33.1 with containerd v2.1.0, calico, apparmor

| type | image | note |
| ---- | ----- | ---- |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_calico_apparmor:latest | point to v0.1.0 |
| dqd | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_calico_apparmor:v0.1.0 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:kubernetes-v1.33.1-calico-apparmor_v0.1.0 | source |
| ctr | ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_calico_apparmor:ctr_v0.1.0 | - |
| ctr | ssst0n3/docker_archive:ctr_kubernetes-v1.33.1-calico-apparmor_v0.1.0 | source |

## usage

### Start and connect

Recommended:

```shell
$ dqd up kubernetes/v1.33.1/containerd/v2.1.0/calico/apparmor
$ ssh dqd-kubernetes-v1.33.1_containerd-v2.1.0_calico_apparmor
```

Fallback without dqd CLI or SSH config:

```shell
$ cd kubernetes/v1.33.1/containerd/v2.1.0/calico/apparmor
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Run a pod with apparmor profile

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# cat << EOF > job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: apparmor-job
spec:
  template:
    spec:
      securityContext:
        appArmorProfile:
          type: RuntimeDefault

      containers:
      - name: task-runner
        image: busybox:1.36
        command:
          - "sh"
          - "-c"
          - |
            cat /proc/self/attr/current
      restartPolicy: Never
EOF
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl apply -f job.yaml
job.batch/apparmor-job created
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl get pods
NAME                 READY   STATUS      RESTARTS   AGE
apparmor-job-dj5hp   0/1     Completed   0          15s
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl logs $(kubectl get pods -l job-name=apparmor-job -o jsonpath='{.items[0].metadata.name}')
cri-containerd.apparmor.d (enforce)
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl get pods -A
NAMESPACE          NAME                                                         READY   STATUS    RESTARTS        AGE
calico-apiserver   calico-apiserver-68f888cfb-btnvj                             1/1     Running   1 (2m53s ago)   71m
calico-apiserver   calico-apiserver-68f888cfb-gzwsb                             1/1     Running   1 (2m53s ago)   71m
calico-system      calico-kube-controllers-7599c95f78-tlvnf                     1/1     Running   1 (2m53s ago)   71m
calico-system      calico-node-2g8t4                                            1/1     Running   1 (2m53s ago)   71m
calico-system      calico-typha-7c747697f-8lnlx                                 1/1     Running   1 (2m53s ago)   71m
calico-system      csi-node-driver-9ssw7                                        2/2     Running   2 (2m53s ago)   71m
calico-system      goldmane-86cd9d999d-6pcnd                                    1/1     Running   1 (2m53s ago)   71m
calico-system      whisker-7f7c56bfb5-5mdzx                                     2/2     Running   2 (2m53s ago)   71m
kube-system        coredns-674b8bbfcf-pclnm                                     1/1     Running   1 (2m53s ago)   12h
kube-system        coredns-674b8bbfcf-w2kxj                                     1/1     Running   1 (2m53s ago)   12h
kube-system        etcd-kubernetes-1-33-1-containerd-2-1-0                      1/1     Running   2 (2m53s ago)   12h
kube-system        kube-apiserver-kubernetes-1-33-1-containerd-2-1-0            1/1     Running   2 (2m53s ago)   12h
kube-system        kube-controller-manager-kubernetes-1-33-1-containerd-2-1-0   1/1     Running   2 (2m53s ago)   12h
kube-system        kube-proxy-vksb8                                             1/1     Running   2 (2m53s ago)   12h
kube-system        kube-scheduler-kubernetes-1-33-1-containerd-2-1-0            1/1     Running   2 (2m53s ago)   12h
tigera-operator    tigera-operator-68f7c7984d-94csl                             1/1     Running   1 (2m53s ago)   71m
```

### versions

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# helm version
version.BuildInfo{Version:"v3.18.3", GitCommit:"6838ebcf265a3842d1433956e8a622e3290cf324", GitTreeState:"clean", GoVersion:"go1.24.4"}
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl version
Client Version: v1.33.1
Kustomize Version: v5.6.0
Server Version: v1.33.1
root@kubernetes-1-33-1-containerd-2-1-0:~# containerd --version
containerd github.com/containerd/containerd/v2 v2.1.0 061792f0ecf3684fb30a3a0eb006799b8c6638a7
root@kubernetes-1-33-1-containerd-2-1-0:~# runc --version
runc version 1.3.0
commit: v1.3.0-0-g4ca628d1
spec: 1.2.1
go: go1.23.8
libseccomp: 2.5.6
root@kubernetes-1-33-1-containerd-2-1-0:~# cat /etc/os-release
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
root@kubernetes-1-33-1-containerd-2-1-0:~# uname -a
Linux kubernetes-1-33-1-containerd-2-1-0 6.8.0-137-generic #137-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 17 20:28:23 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=kubernetes/v1.33.1/containerd/v2.1.0/calico/apparmor
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/kubernetes-v1.33.1_containerd-v2.1.0_calico:ctr_v0.1.0
...
RUN apt update && apt install -y apparmor
```

* ssh root/root 10.0.2.16 to debug.
