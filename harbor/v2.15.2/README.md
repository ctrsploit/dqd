# harbor v2.15.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:latest | points to `v0.1.14` |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.14 | official default Harbor v2.15.2 deployment |
| ctr | ghcr.io/ctrsploit/harbor-v2.15.2:ctr_v0.1.14 | base image for `vul/harbor-*` envs |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.13 | superseded: runner AppArmor is fully locked down (sudo .complain write → Permission denied, apparmor_parser not available); pivoted to build-time-only disable_apparmor() in init.sh using buildkit exec's privileged context |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.12 | superseded: sudo .complain write still failed silently (2>/dev/null hid the real error); install apparmor-utils for aa-complain, show errors, and add aa-complain as method 1 |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.11 | superseded: runner runs as user "runner" not root, so .complain write and apparmor_parser -R both got "Access denied / not policy admin"; prefix neutralize with sudo (passwordless on GHA) |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.10 | superseded: runner-level AppArmor complain write didn't stop the DENIED (profile likely in a nested/loaded form the .complain write missed); added apparmor_parser -R fallback + diagnostic logging in script/ci_run.sh |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.9 | superseded: in-buildkit AppArmor complain-mode fix failed (buildkit exec has its own AppArmor ns, can't see host unix-chkpwd profile); moved the neutralization to the CI runner root in script/ci_run.sh |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.8 | superseded: harbor-log crash-looped (host AppArmor denied unix_chkpwd dac_override); added apparmor=unconfined override |

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
<!-- VERIFY -->
$ curl -fsSL -u admin:Harbor12345 http://127.0.0.1:21521/api/v2.0/users/current
<!-- VERIFY -->
```

Or from inside the VM:

```shell
$ ssh dqd-harbor-v2.15.2
root@harbor-v2-15-2:~# docker ps --format '{{.Names}}\t{{.Status}}'
<!-- VERIFY -->
root@harbor-v2-15-2:~# curl -fsSL http://127.0.0.1/api/v2.0/health
<!-- VERIFY -->
```

Default credentials: `admin` / `Harbor12345` (official Harbor default).

### versions

```shell
root@harbor-v2-15-2:~# docker version
<!-- VERIFY -->
root@harbor-v2-15-2:~# cat /etc/os-release
<!-- VERIFY -->
root@harbor-v2-15-2:~# uname -a
<!-- VERIFY -->
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
