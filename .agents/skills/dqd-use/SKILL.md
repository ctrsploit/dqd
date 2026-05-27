---
name: dqd-use
description: "Use when operating existing dqd environments with the runtime CLI: listing environments, showing running environments, inspecting image and SSH details, starting or stopping environments, choosing KVM behavior, and SSH access without building images or changing repository files."
---

# dqd Use

Use this skill for runtime operations on existing dqd environments. Do not use it for building images, migrating from `docker_archive`, assigning ports, or changing repository config; use `dqd-dev` and `Makefile` for those tasks.

## CLI First

Prefer the CLI over direct `docker compose` commands:

```bash
dqd list [prefix]
dqd ps [prefix]
dqd info <env-path>
dqd up <env-path> [--kvm=true|false]
dqd ssh <env-path>
dqd down <env-path>
```

If `dqd` is not in `PATH`, install it from the repository:

```bash
script/install_cli.sh
export PATH="$HOME/.local/bin:$PATH"
rehash
```

The CLI can also be run directly from the repository:

```bash
./bin/dqd list
./bin/dqd info runc/v0.0.5
```

## Command Semantics

- `dqd list [prefix]`: list known environments, grouped by top-level path; examples: `dqd list`, `dqd list vul`, `dqd list runc/v0.0.5`.
- `dqd ps [prefix]`: show running dqd environments only. If no matching environment is running, it prints `No running dqd environments.`
- `dqd info <env>`: show image, version, compose project, dqd image tag, and SSH port.
- `dqd up <env>`: start an environment. It auto-enables the KVM overlay when `/dev/kvm` exists and `<env>/docker-compose.kvm.yml` exists.
- `dqd up <env> --kvm=true`: require KVM; fail if `/dev/kvm` or the KVM compose overlay is unavailable.
- `dqd up <env> --kvm=false`: force non-KVM startup.
- `dqd ssh <env>`: SSH into the environment.
- `dqd down <env>`: stop the environment.

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
