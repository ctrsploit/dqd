---
name: dqd-dev
description: Use when developing dqd itself, especially adding or migrating environments from docker_archive, editing Makefile or CI behavior, assigning SSH ports, updating README and ssh_config files, and validating changes before commit.
---

# dqd Dev

Use this skill for repository changes. Use `dqd-use` when only running existing environments.

## Standard Workflow

1. Create a dedicated branch before any edits:
   ```bash
   git checkout main && git pull && git checkout -b <env-name>
   ```
2. Read `Makefile`, target `<ENV>/.env`, and nearby environments before editing.
3. Keep generated artifacts out of git, especially `*.qcow2`.
4. Validate with the smallest real target that covers the change.
5. Commit only related files.

## Migrating From docker_archive

When migrating one environment:

- Create a dedicated branch: `git checkout main && git pull && git checkout -b <env-name>`.
- Copy only files needed by dqd, normally `.env`, `Dockerfile`, `README.md`, `docker-compose.yml`, `docker-compose.kvm.yml`, and `ssh`.
- Do not migrate old `docker-compose.swr-mirror.yml` unless explicitly requested.
- Do not migrate old `scp` helpers unless explicitly requested.
- Change image references from `ssst0n3/docker_archive` to `ghcr.io/ctrsploit`.
- Prefer already-migrated dqd base images instead of using `docker_archive` as a base.
- Check that the base image's `SSH_PUB_KEY` ARG default uses the dqd key (`default@dqd`), not the old `docker_archive` key. If the base uses the old key, update the comment only (do NOT change the key type — older Ubuntu/Debian releases may not support ed25519).
- ed25519 requires OpenSSH ≥6.5 (Ubuntu 14.04+). For older bases (Ubuntu 12.04, Debian ≤7), use ecdsa-sha2-nistp256 (`~/.ssh/keys/dqd_ecdsa-sha2-nistp256`). Both keys are already present in the repo's key directory.
- Check that `<ENV>/.env` does not contain `IDENTITY_FILE` pointing to the old docker_archive key. The dqd `ssh_config/config` uses `~/.ssh/keys/dqd` globally via the `Host dqd-*` wildcard.
- Preserve original behavior and README examples unless the dqd migration requires a change.
- Update top-level `README.md` and `ssh_config/config`.
- Use `ENV=<env-path>`, not old `DIR=<env-path>`, in docs and commands.
- In README's `### versions` section, use `<!-- VERIFY -->` placeholder comments for all runtime-dependent output. The line above each placeholder must be the expected prompt + command (e.g., `root@<hostname>:~# runc --version`). Standard `### versions` commands are: component version command (e.g., `runc --version`, `containerd --version`), `cat /etc/os-release`, and `uname -a`. Leave `<!-- VERIFY -->` placeholders in place until the image has been built by CI and the user requests a README update.
- After creating all files, run `make ctr ENV=<env-path>` to validate the Dockerfile builds (base image exists, URLs are reachable). Do not run `make vm` or `make dqd` locally — those steps require pushes and produce large artifacts; they belong to CI.

For runc/containerd `-dbg` variants (application-level debugging with dlv wrapper):

- The base image is a ctr image (e.g., `ghcr.io/ctrsploit/runc-v1.0.0-rc2:ctr_v0.1.0`), not an ubuntu base.
- Copy `runc.debug` and `attach.sh` from an existing `-dbg` variant in dqd.
- Do NOT set `CI_MAKE_TARGETS` — the default `all` flow is correct.
- Add `QEMU_HOSTFWD` environment variable and dlv ports (2346/2347) to `docker-compose.yml`.
- Use `make dbg ENV=<env-path>` in README's `## build` section, as the `dbg` target refers to the component, not the kernel.

For simple runc archive migrations on Ubuntu 16.04, follow the existing `runc/v0.0.x` pattern:

- `VERSION=v0.3.0`
- `VERSION_IMAGE_UBUNTU=0.3.0`
- base image `ghcr.io/ctrsploit/ubuntu-16.04:ctr_v0.3.0`
- artifact URL `https://github.com/ssst0n3/container-debug-artifacts/releases/download/runc/runc-v${VERSION_RUNC}-debug`

## CI And Build Targets

CI entrypoint:

```bash
make ci ENV=<env-path>
```

If `<ENV>/.env` does not define `CI_MAKE_TARGETS`, CI runs `all`.

**When to set `CI_MAKE_TARGETS`:**

Only set `CI_MAKE_TARGETS` when the environment needs a non-default CI flow. Before setting it, verify why `all` is insufficient.

The `dbg` target (which adds `nokaslr` kernel argument for kernel-level debugging) must NOT be used for runc/containerd `-dbg` variants that only wrap the component with dlv. Those are application-level debug images — use the default `all` flow.

Checklist before setting `CI_MAKE_TARGETS` to `dbg`:

- Does `<ENV>/Dockerfile.dbg` exist? If not, do NOT use `dbg`.
- Is the debugging target the Linux kernel itself? If it is only application-level (dlv/gdb wrapping a userspace binary), do NOT use `dbg`.

Example of when `dbg` IS appropriate:

```env
CI_MAKE_TARGETS=check-ssh-ports dbg push post-clean generate_ssh_config
```

Applies only to environments like `ubuntu/22.04-dbg` that have `Dockerfile.dbg` and need kernel debug support.

## SSH Port Rules

- SSH ports must be globally unique.
- Preserve the docker_archive port unless it conflicts with an existing dqd environment.
- If there is a repo conflict, choose the nearest free port in the same family/range.
- Keep `<ENV>/docker-compose.yml`, `<ENV>/ssh`, `ssh_config/config`, and README examples synchronized.

Common conventions:

- Ubuntu: `YY040`, variants use nearby ports.
- Debian: `major000`.
- CentOS: `1<major>000`.
- runc early versions: `10010`, `10020`, `10021`, `10030`, etc.
- containerd: encode major/minor/patch, variants use nearby ports.
- Docker: encode major/minor/patch compactly when possible.
- Kubernetes: encode version/stack, then role offsets.
- CVE/vul: prefer the CVE numeric suffix; use a year/category prefix for short suffixes.

## Validation Checklist

Run what matches the scope:

```bash
make env ENV=<env-path>
docker compose -f <env-path>/docker-compose.yml config
make check-ssh-ports
# verify IDENTITY_FILE is consistent with the base image's SSH key type
# ed25519: modern systems (Ubuntu ≥14.04) → ~/.ssh/keys/dqd
# ecdsa: old systems (Ubuntu 12.04) → ~/.ssh/keys/dqd_ecdsa-sha2-nistp256
git diff --check
make ci ENV=<env-path> CI_MAKE_TARGETS="ctr"
```

Before committing, validate `<ENV>/.env` for integrity:

```bash
# Check for duplicate keys (each key should appear exactly once)
grep -oP '^\w+=' <ENV>/.env | sort | uniq -d
# Check total line count matches expected
wc -l <ENV>/.env
```

When validation passes, commit the changes:

```bash
git add <ENV>/ README.md ssh_config/config
git commit -m "<env-name>"
```

For scripts:

```bash
bash -n <script>
sh -n <script>
```
