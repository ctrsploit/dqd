---
name: dqd-dev
description: Use when developing dqd itself, especially adding or migrating environments from docker_archive, editing Makefile or CI behavior, assigning SSH ports, updating README and ssh_config files, and validating changes before commit.
---

# dqd Dev

Use this skill for repository changes. Use `dqd-use` when only running existing environments.

## Standard Workflow

1. Work from a branch or worktree based on current `main`.
2. Read `Makefile`, target `<ENV>/.env`, and nearby environments before editing.
3. Keep generated artifacts out of git, especially `*.qcow2`.
4. Validate with the smallest real target that covers the change.
5. Commit only related files.

## Migrating From docker_archive

When migrating one environment:

- Copy only files needed by dqd, normally `.env`, `Dockerfile`, `README.md`, `docker-compose.yml`, `docker-compose.kvm.yml`, and `ssh`.
- Do not migrate old `docker-compose.swr-mirror.yml` unless explicitly requested.
- Do not migrate old `scp` helpers unless explicitly requested.
- Change image references from `ssst0n3/docker_archive` to `ghcr.io/ctrsploit`.
- Prefer already-migrated dqd base images instead of using `docker_archive` as a base.
- Preserve original behavior and README examples unless the dqd migration requires a change.
- Update top-level `README.md` and `ssh_config/config`.
- Use `ENV=<env-path>`, not old `DIR=<env-path>`, in docs and commands.

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

If `<ENV>/.env` does not define `CI_MAKE_TARGETS`, CI runs `all`. For nonstandard flows, set `CI_MAKE_TARGETS` in `.env`; for example debug images may need:

```env
CI_MAKE_TARGETS=check-ssh-ports dbg push post-clean generate_ssh_config
```

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
git diff --check
make ci ENV=<env-path> CI_MAKE_TARGETS="ctr"
```

For scripts:

```bash
bash -n <script>
sh -n <script>
```

For built container images, smoke-test installed versions with `docker run --rm <ctr-image> ...` when practical.
