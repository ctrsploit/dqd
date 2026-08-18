# harbor v2.15.2

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/harbor-v2.15.2:v0.1.0 | official default Harbor v2.15.2 deployment |
| ctr | ghcr.io/ctrsploit/harbor-v2.15.2:ctr_v0.1.0 | base image for `vul/harbor-*` envs |

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

Harbor is installed at first boot by a systemd oneshot service (`harbor-init.service`). First `dqd up` takes a few minutes while the installer downloads and starts the 9 Harbor containers; subsequent boots skip the install (the service is idempotent).

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
FROM ghcr.io/ctrsploit/docker-v28.2.2:ctr_v0.1.0
...
COPY service/init.service /usr/lib/systemd/system/
RUN systemctl enable harbor-init.service
```

* Harbor is installed at first boot via a systemd oneshot (`harbor-init.service` → `harbor-init.sh`), not at image build time. The official `install.sh` runs `docker compose up -d`, whose containers are not captured by the build-time overlayfs snapshot trick, so a boot-time install is the correct pattern (same approach as `ctf/cve-2019-14271`'s `setup-challenge.service`).
* `harbor.yml` is configured with only `hostname: 127.0.0.1`; all other settings are template defaults (port 80, `admin`/`Harbor12345`, `project_creation_restriction: everyone`, no https/proxy/internal_tls).
* `SIZE=20G` — Harbor's 9 containers plus PostgreSQL/Redis data need more than the default 10G.
* ssh root/root 10.0.2.16 to debug.
