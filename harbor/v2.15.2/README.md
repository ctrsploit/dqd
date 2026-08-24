# harbor v2.15.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:latest | points to `v0.1.19` |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.19 | official default Harbor v2.15.2 deployment |
| ctr | ghcr.io/ctrsploit/harbor-v2.15.2:ctr_v0.1.19 | base image for `vul/harbor-*` envs |

Reusable Harbor v2.15.2 runtime environment for `vul/harbor-*` reproduction envs to `FROM`. This image contains **only** a stock Harbor deployment — no vulnerability setup, no attacker accounts, no reproduction scripts. Those belong to the `vul` layer.

## usage

### Start and connect

Recommended:

```shell
$ dqd up harbor/v2.15.2
$ ssh dqd-harbor-v2.15.2
```

Fallback without dqd CLI or SSH config:

```shell
$ cd harbor/v2.15.2
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

Harbor is installed at **build time** via the overlayfs snapshot trick: the Dockerfile boots systemd under buildkit (`--security=insecure` + `exec /sbin/init`), `init.sh` runs the official `install.sh` (which `docker compose up -d`s 9 containers with `restart: always`), then the resulting `/var/lib/docker` state is snapshotted into the image. At runtime the 9 Harbor containers come up automatically via `restart: always` — no first-boot delay.

### Access Harbor

The Harbor web UI and API are exposed on host port `21521` (container port 80):

```shell
$ curl -fsSL http://127.0.0.1:21521/api/v2.0/health
{"status":"healthy","components":[{"name":"core","status":"healthy"},{"name":"database","status":"healthy"},{"name":"jobservice","status":"healthy"},{"name":"portal","status":"healthy"},{"name":"redis","status":"healthy"},{"name":"registry","status":"healthy"},{"name":"registryctl","status":"healthy"}]}
$ curl -fsSL -u admin:Harbor12345 http://127.0.0.1:21521/api/v2.0/users/current
{"user_id":1,"username":"admin","realname":"system admin","comment":"admin user","sysadmin_flag":true,"admin_role_in_auth":false,"creation_time":"2026-08-24T02:01:55.083Z","update_time":"2026-08-24T02:01:55.559Z"}
```

Or from inside the VM:

```shell
$ ssh dqd-harbor-v2.15.2
root@harbor-v2-15-2:~# docker ps --format '{{.Names}}\t{{.Status}}'
harbor-log	Up 14 minutes (healthy)
redis	Up 2 minutes (healthy)
harbor-portal	Up 2 minutes (healthy)
harbor-db	Up 2 minutes (healthy)
registry	Up 2 minutes (healthy)
registryctl	Up 2 minutes (healthy)
harbor-core	Up 2 minutes (healthy)
nginx	Up 2 minutes (healthy)
harbor-jobservice	Up About a minute (healthy)
root@harbor-v2-15-2:~# curl -fsSL http://127.0.0.1/api/v2.0/health
{"status":"healthy","components":[{"name":"core","status":"healthy"},{"name":"database","status":"healthy"},{"name":"jobservice","status":"healthy"},{"name":"portal","status":"healthy"},{"name":"redis","status":"healthy"},{"name":"registry","status":"healthy"},{"name":"registryctl","status":"healthy"}]}
```

Default credentials: `admin` / `Harbor12345` (official Harbor default).

### versions

```shell
root@harbor-v2-15-2:~# docker version
Client: Docker Engine - Community
 Version:           28.2.2
 API version:       1.50
 Go version:        go1.24.3
 Git commit:        e6534b4
 Built:             Fri May 30 12:07:27 2025
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          28.2.2
  API version:      1.50 (minimum version 1.24)
  Go version:       go1.24.3
  Git commit:       45873be
  Built:            Fri May 30 12:07:27 2025
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.7.27
  GitCommit:        05044ec0a9a75232cad458027ca83437aae3f4da
 runc:
  Version:          1.2.5
  GitCommit:        v1.2.5-0-g59923ef
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@harbor-v2-15-2:~# cat /etc/os-release
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
root@harbor-v2-15-2:~# uname -a
Linux docker-28-2-2 6.8.0-138-generic #138-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 31 22:41:49 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=harbor/v2.15.2
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/docker-v28.2.2:ctr_v0.1.0
...
RUN --mount=type=cache,id=harbor-v2.15.2-snapshots,target=/var/lib/docker \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* Harbor is installed at **build time** using the same overlayfs snapshot trick as `ingress-nginx` / k8s `init`/`calico`: systemd boots under buildkit, `init.sh` runs the official `install.sh`, and `/var/lib/docker` is snapshotted. This differs from k8s envs which snapshot containerd's `/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs` — Harbor uses dockerd, so we snapshot `/var/lib/docker` instead.
* All 9 Harbor containers use `restart: always`, so they come up automatically at VM boot with no first-boot install delay.
* `harbor.yml` is configured with only `hostname: harbor.local`; all other settings are template defaults (port 80, `admin`/`Harbor12345`, `project_creation_restriction: everyone`, no https/proxy/internal_tls).
* `SIZE=20G` — Harbor's 9 containers plus PostgreSQL/Redis data need more than the default 10G.
* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* ssh root/root 10.0.2.16 to debug.
