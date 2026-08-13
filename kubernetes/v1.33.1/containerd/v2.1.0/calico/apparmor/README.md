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
<!-- VERIFY -->
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl get pods
<!-- VERIFY -->
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl logs $(kubectl get pods -l job-name=apparmor-job -o jsonpath='{.items[0].metadata.name}')
<!-- VERIFY -->
```

### Inspect built-in pods

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl get pods -A
<!-- VERIFY -->
```

### versions

```shell
root@kubernetes-1-33-1-containerd-2-1-0:~# helm version
<!-- VERIFY -->
root@kubernetes-1-33-1-containerd-2-1-0:~# kubectl version
<!-- VERIFY -->
root@kubernetes-1-33-1-containerd-2-1-0:~# containerd --version
<!-- VERIFY -->
root@kubernetes-1-33-1-containerd-2-1-0:~# runc --version
<!-- VERIFY -->
root@kubernetes-1-33-1-containerd-2-1-0:~# cat /etc/os-release
<!-- VERIFY -->
root@kubernetes-1-33-1-containerd-2-1-0:~# uname -a
<!-- VERIFY -->
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
