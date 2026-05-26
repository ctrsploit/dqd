# CLAUDE.md (`dqd`)

Repository for containerized Linux environments used in security research and debugging.

## Skills

This repository has three project skills. Load them when relevant:

- **dqd-dev** — Developing dqd itself: migrating environments from `docker_archive`, editing Makefile/CI, assigning SSH ports, updating README/ssh_config. Load for any repository changes.
- **dqd-use** — Operating existing environments with the `dqd` CLI. Load for `dqd up`/`dqd ssh`/`dqd list` workflows.
- **dqd-verify** — Filling in `<!-- VERIFY -->` placeholders in README files with live runtime output. Load when asked to "验证版本" or update README outputs.

Skills live in `.agents/skills/<name>/SKILL.md` (the single physical source, following the Agent Skills open standard). `.claude/skills`, `.codex/skills`, and `.opencode/skills` are symlinks for cross-tool compatibility.

## Build Commands

```bash
make help                          # list all targets
make env ENV=<env-path>            # preflight
make ctr ENV=<env-path>            # build container image
make vm ENV=<env-path>             # convert to vm.qcow2
make dqd ENV=<env-path>            # build DQD image
make all ENV=<env-path>            # full pipeline
make ci ENV=<env-path>             # CI entrypoint
make check-ssh-ports               # verify SSH port uniqueness
```

## Key Conventions

- Every environment: `<ENV>/.env`, `Dockerfile`, `docker-compose.yml`, `docker-compose.kvm.yml`, `ssh`, `README.md`
- Use `ENV=<env-path>`, not `DIR=<env-path>`, in docs and commands
- SSH ports must be globally unique across all environments
- No `docker-compose.swr-mirror.yml` or `scp` files (docker_archive-specific)
- README runtime output uses `<!-- VERIFY -->` placeholders until CI builds the image
- Image registry: `ghcr.io/ctrsploit` (not `ssst0n3/docker_archive`)
- Base images reference dqd images, never docker_archive as base

See `AGENTS.md` for detailed conventions, port design rules, and CI workflow docs.
