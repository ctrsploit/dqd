---
name: dqd-use
description: "Use when operating existing dqd environments with the runtime CLI: listing environments, showing running environments, inspecting image and SSH details, starting or stopping environments, choosing KVM behavior, and SSH access without building images or changing repository files."
---

# dqd Use

Use this skill for runtime operations on existing dqd environments. Do not use it for building images, migrating from `docker_archive`, assigning ports, or changing repository config; use `dqd-dev` and `Makefile` for those tasks.

## CLI First

The `dqd` command is the Go CLI (`cli/`, built into `bin/dqd` by `make cli`). It works both inside a checkout and standalone (it embeds a config snapshot of all environments). The legacy bash CLI lives at `bin/dqd-sh` — deprecated, avoid it.

```bash
dqd list [prefix]
dqd ps [prefix]
dqd info <env-path>
dqd up <env-path> [--kvm=true|false]
dqd ready <env-path>
dqd ssh <env-path> [command...]
dqd down <env-path>
dqd update [--check]
```

If `dqd` is not in `PATH`, install it (no checkout needed):

```bash
go install github.com/ctrsploit/dqd/cli/cmd/dqd@latest
rehash
```

From a checkout you can also build and run it directly:

```bash
make cli          # builds bin/dqd
./bin/dqd list
./bin/dqd info runc/v0.0.5
```

(`script/install_cli.sh` and `bin/dqd-sh` are deprecated.)

## Command Semantics

- `dqd list`: per-component summary (component, env count). `dqd list <component-or-prefix>` expands to grouped paths; `dqd list --all` dumps everything. Entries without a compose file are suffixed `(build-only)`.
- `dqd ps [prefix]`: show running dqd environments. If no matching environment is running, it prints `No running dqd environments.`
- `dqd info <env>`: show image, ssh alias, version, compose project, dqd image tag, SSH port and live status.
- `dqd up <env>`: start an environment. It auto-enables the KVM overlay when `/dev/kvm` exists and `<env>/docker-compose.kvm.yml` exists.
- `dqd up <env> --kvm=true`: require KVM; fail if `/dev/kvm` or the KVM compose overlay is unavailable.
- `dqd up <env> --kvm=false`: force non-KVM startup.
- `dqd ready <env>`: wait until the VM's SSH endpoint answers (default 3s interval, 300s timeout).
- `dqd ssh <env>`: interactive shell (native SSH, no sshpass). `dqd ssh <env> -- cmd` runs a remote command.
- `dqd down <env>`: stop the environment.
- `dqd update`: refresh the remote catalog; `--check` only reports differences from the embedded snapshot.

Environment arguments resolve in order: local directory (repo/dev mode) → remote cache → embedded snapshot → remote fetch.

## Direct Fallback

Use direct compose commands only when debugging the CLI or when explicitly requested:

```bash
docker compose -f <env-path>/docker-compose.yml config
docker compose -f <env-path>/docker-compose.yml up -d
docker compose -f <env-path>/docker-compose.yml -f <env-path>/docker-compose.kvm.yml up -d
```

Only use `docker-compose.kvm.yml` directly when `/dev/kvm` exists.

## Runtime Notes

- The CLI is use-only. It intentionally has no build command.
- Build and development workflows stay in `Makefile`.
- The source of truth for SSH ports is `<env>/docker-compose.yml`.
- A local process occupying a configured SSH port is a runtime issue; do not change repository port config solely for that.
- Remote-update prompts never block non-interactive runs; disable remote checks with `--no-update`.
- When environment files change, regenerate and commit `catalog.json` via `make generate-catalog` (CI-facing freshness gate: `make check-catalog`).
