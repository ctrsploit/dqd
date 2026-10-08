# harbor v2.15.3

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.3:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.3:v0.1.0 | official default Harbor v2.15.3 deployment |
| ctr | ghcr.io/ctrsploit/harbor-v2.15.3:ctr_v0.1.0 | base image for `vul/harbor-*` envs |

Reusable Harbor v2.15.3 runtime environment for `vul/harbor-*` reproduction envs to `FROM`. This image contains **only** a stock Harbor deployment — no vulnerability setup, no attacker accounts, no reproduction scripts. Those belong to the `vul` layer.

## usage

### Start and connect

Recommended:

```shell
$ dqd up harbor/v2.15.3
$ ssh dqd-harbor-v2.15.3
```

Fallback without dqd CLI or SSH config:

```shell
$ cd harbor/v2.15.3
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

Harbor is installed at **build time** via the overlayfs snapshot trick: the Dockerfile boots systemd under buildkit (`--security=insecure` + `exec /sbin/init`), `init.sh` runs the official `install.sh` (which `docker compose up -d`s 9 containers with `restart: always`), then the resulting `/var/lib/docker` state is snapshotted into the image. At runtime, `start.sh` (enabled as a systemd oneshot) starts harbor-log first, waits for it to become healthy, then runs `docker compose up -d` to bring up the remaining 8 containers — this ordering is required because all non-log containers depend on harbor-log's syslog port `127.0.0.1:1514` for their logging driver.

### Access Harbor

The Harbor web UI and API are exposed on host port `21531` (container port 80):

```shell
$ curl -fsSL http://127.0.0.1:21531/api/v2.0/health
{"components":[{"name":"core","status":"healthy"},{"name":"database","status":"healthy"},{"name":"jobservice","status":"healthy"},{"name":"portal","status":"healthy"},{"name":"redis","status":"healthy"},{"name":"registry","status":"healthy"},{"name":"registryctl","status":"healthy"}],"status":"healthy"}
$ curl -fsSL -u admin:Harbor12345 http://127.0.0.1:21531/api/v2.0/users/current
{"admin_role_in_auth":false,"comment":"admin user","creation_time":"2026-10-08T07:09:19.451Z","realname":"system admin","sysadmin_flag":true,"update_time":"2026-10-08T07:09:19.907Z","user_id":1,"username":"admin"}
```

Or from inside the VM:

```shell
$ ssh dqd-harbor-v2.15.3
root@harbor-v2-15-3:~# docker ps --format '{{.Names}}\t{{.Status}}'
nginx	Up 32 seconds (healthy)
harbor-jobservice	Up 31 seconds (healthy)
harbor-core	Up 32 seconds (healthy)
redis	Up 33 seconds (healthy)
registry	Up 33 seconds (healthy)
harbor-db	Up 33 seconds (healthy)
harbor-portal	Up 33 seconds (healthy)
registryctl	Up 33 seconds (healthy)
harbor-log	Up About a minute (healthy)
root@harbor-v2-15-3:~# curl -fsSL http://127.0.0.1/api/v2.0/health
{"components":[{"name":"core","status":"healthy"},{"name":"database","status":"healthy"},{"name":"jobservice","status":"healthy"},{"name":"portal","status":"healthy"},{"name":"redis","status":"healthy"},{"name":"registry","status":"healthy"},{"name":"registryctl","status":"healthy"}],"status":"healthy"}
```

Default credentials: `admin` / `Harbor12345` (official Harbor default).

### versions

```shell
root@harbor-v2-15-3:~# docker version
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
  Built:             Fri May 30 12:07:27 2025
  OS/Arch:           linux/amd64
  Experimental:      false
 containerd:
  Version:          1.7.27
  GitCommit:        05044ec0a9a75232cad458027ca83437aae3f4da
 runc:
  Version:          1.2.5
  GitCommit:        v1.2.5-0-g59923ef
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
root@harbor-v2-15-3:~# cat /etc/os-release
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
root@harbor-v2-15-3:~# uname -a
Linux docker-28-2-2 6.8.0-146-generic #146-Ubuntu SMP PREEMPT_DYNAMIC Thu Sep 3 16:12:30 UTC 2026 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=harbor/v2.15.3
```

## for developers

```dockerfile
# syntax=docker/dockerfile:1-labs
FROM ghcr.io/ctrsploit/docker-v28.2.2:ctr_v0.1.0
...
RUN --mount=type=cache,id=harbor-v2.15.3-snapshots,target=/var/lib/docker \
    --security=insecure \
    ["/bin/sh", "-c", "cat /dev/kmsg 2>/dev/null & exec /sbin/init --log-target=kmsg"]
```

* Harbor is installed at **build time** using the same overlayfs snapshot trick as `ingress-nginx` / k8s `init`/`calico`: systemd boots under buildkit, `init.sh` runs the official `install.sh`, and `/var/lib/docker` is snapshotted. This differs from k8s envs which snapshot containerd's `/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs` — Harbor uses dockerd, so we snapshot `/var/lib/docker` instead.
* All 9 Harbor containers use `restart: always`, but the build snapshot captures them stopped. At VM boot, `start.sh` (systemd oneshot) starts harbor-log first, waits for healthy, then `docker compose up -d` for the remaining 8 — required because they depend on harbor-log's syslog port `127.0.0.1:1514` for their logging driver.
* `harbor.yml` is configured with only `hostname: harbor.local`; all other settings are template defaults (port 80, `admin`/`Harbor12345`, `project_creation_restriction: everyone`, no https/proxy/internal_tls). v2.15.3's template adds `network.allow_private_network_access: false` (GHSA-2phj-cp9f-qq6w SSRF fix) — left at its default `false`, which is the official default deployment.
* Same base image as `harbor/v2.15.2` (`docker-v28.2.2:ctr_v0.1.0`), deliberately: the two envs differ only in the Harbor version, so `vul/harbor-*` envs built on them isolate the Harbor-version variable.
* `SIZE=20G` — Harbor's 9 containers plus PostgreSQL/Redis data need more than the default 10G.
* build logs (systemd + init.sh, written to `/dev/kmsg`) are surfaced to the build log via a backgrounded `cat /dev/kmsg`; use `dmesg -w` only when debugging interactively.
* ssh root/root 10.0.2.16 to debug.
