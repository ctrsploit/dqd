# CTF Challenge: GHSA-2phj-cp9f-qq6w (Harbor webhook SSRF)

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ctf-ghsa-2phj-cp9f-qq6w:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/ctf-ghsa-2phj-cp9f-qq6w:v0.1.0 | stock Harbor v2.15.2 (vulnerable) + flag-bearing fake IMDS + `ctf` player account |
| ctr | ghcr.io/ctrsploit/ctf-ghsa-2phj-cp9f-qq6w:ctr_v0.1.0 | - |

CTF packaging of [GHSA-2phj-cp9f-qq6w](https://github.com/goharbor/harbor/security/advisories/GHSA-2phj-cp9f-qq6w) (no CVE alias): SSRF in Harbor webhook delivery, fixed in v2.15.3 (affected `>= 1.7.0, < 2.13.6` / `>= 2.14.0, < 2.14.5` / `>= 2.15.0, < 2.15.3`). The flag is the `SecretAccessKey` of the instance-role credentials served by a fake IMDS at `169.254.169.254` — reachable only from the Harbor deployment's egress, never from your shell. This env `FROM`s the stock `harbor/v2.15.2` deployment; for the fixed behavior see `vul/ghsa-2phj-cp9f-qq6w` and `harbor/v2.15.3`.

The exploit technique is yours to find — see [writeup.md](./writeup.md) once solved.

## usage

### Start and connect

Recommended:

```shell
$ dqd up ctf/ghsa-2phj-cp9f-qq6w
$ ssh dqd-ctf-ghsa-2phj-cp9f-qq6w
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ctf/ghsa-2phj-cp9f-qq6w
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

The Harbor web UI and API are exposed on host port `21525`:

```shell
$ curl -fsSL http://127.0.0.1:21525/api/v2.0/health
<!-- VERIFY -->
```

### Without kvm

```shell
$ docker compose -f docker-compose.yml up -d
```

### challenge description

You are the low-privilege `ctf` user (password `ctf`) on a VM running the stock, vulnerable Harbor v2.15.2 deployment (9 containers, default `project_creation_restriction: everyone`).

What you hold:

- a Harbor account `attacker` / `Attacker12345` — unprivileged; with `project_creation_restriction: everyone`, creating a project makes you its ProjectAdmin
- `sudo`, whitelisted to exactly four non-executing docker commands, passwordless: `docker login`, `docker pull`, `docker tag`, `docker push 127.0.0.1/*` (`127.0.0.0/8` is a default insecure registry for dockerd)
- `curl`, and the Harbor API/UI at `http://127.0.0.1` inside the VM (host port `21525`)

What you do not hold: root (password locked, no root SSH), `docker run`/`exec`/`inspect` or any docker state access, and any network path to the metadata service — VM egress to `169.254.169.254` is firewalled; only the Harbor deployment's container egress can reach it.

Goal: the fake instance metadata service at `http://169.254.169.254/` holds a secret of the form `flag{...}`. Get it out. Harbor's webhook target validation is where to look.

## writeup

See [writeup.md](./writeup.md).

### versions

```shell
ctf@harbor-v2-15-2:~$ curl -fsSL http://127.0.0.1/api/v2.0/health
<!-- VERIFY -->
ctf@harbor-v2-15-2:~$ curl -s -u attacker:Attacker12345 http://127.0.0.1/api/v2.0/users/current
<!-- VERIFY -->
ctf@harbor-v2-15-2:~$ sudo -l
<!-- VERIFY -->
ctf@harbor-v2-15-2:~$ cat /etc/os-release
<!-- VERIFY -->
ctf@harbor-v2-15-2:~$ uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=ctf/ghsa-2phj-cp9f-qq6w
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ctf-ghsa-2phj-cp9f-qq6w:ctr_v0.1.0
```

* `FROM` the stock `harbor/v2.15.2` ctr image (published as `ctr_v0.1.21`) directly — a sibling of `vul/ghsa-2phj-cp9f-qq6w`, not a child: the vul env's `imds.service` redirects VM-local traffic to `169.254.169.254` too, which would be a direct-access bypass here. Harbor itself is untouched.
* The flag carrier is `flag-imds.service`, enabled at build time. It serves the flag (read from `/root/flag`, `chmod 400 root:root`) as the `SecretAccessKey` of fake instance-role credentials and answers **every** request with `404` + that body — error-status response bodies are what jobservice writes into the project-readable webhook execution log, so the 404 body is the only channel through which the flag can leave.
* Trust boundary, enforced by three idempotent iptables rules in `flag-imds.service`: nat `PREROUTING` REDIRECT `169.254.169.254:80 → :8169` (container egress only — no `OUTPUT` redirect), filter `OUTPUT REJECT` for `169.254.169.254` (VM-local curl and dockerd fetches), filter `INPUT REJECT` on `lo` for `:8169` (direct connects to the listener; redirected container traffic arrives on the bridge interface and passes). The rules reference no docker-network addresses, so they survive docker subnet renumbering.
* `setup-challenge.sh` (boot, after `start.service` has brought up the Harbor containers): waits for `/api/v2.0/health`, creates the `attacker` player account via the admin API (v2.15 rejects API-triggered self-registration; 409/401 on later boots are tolerated), then rotates the stock `admin` password so only the unprivileged path remains.
* `ctf` user hardening follows `ctf/cve-2026-50195`: root password locked, `PermitRootLogin no`, sudoers whitelist `sudoers.ctf` (`chmod 440`), no docker-group membership.
* `SIZE=20G`, inherited from the base (Harbor's 9 containers plus PostgreSQL/Redis data).
* Root is unreachable by design (password locked, `PermitRootLogin no` — console included; the journal and `iptables` state are likewise root-only). To debug the env itself, rebuild locally with the two locking `RUN` layers removed from the Dockerfile.
