# AGENTS Guide (`dqd`)
This file defines repository-specific rules for autonomous coding agents.
## 1) Repository overview
- Build orchestration is centralized in `Makefile`.
- CI workflow is `.github/workflows/make.yml`.
- Versioned environment directories include:
  - `ubuntu/24.04`
  - `runc/v1.2.5`
  - `containerd/v2.0.3`
  - `dqd/v0.4.0`
  - `kubernetes/v1.32.2/containerd/v2.0.3/base`
- Every environment loads config from `<ENV>/.env`.
- Main generated artifact is `<ENV>/vm.qcow2` (gitignored by `*.qcow2`).
- Run commands from repository root unless explicitly documented otherwise.
## 2) Canonical build/lint/test commands
### 2.1 Discovery and preflight
```bash
make help
make env ENV=<env-path>
```
Examples:
```bash
make env ENV=ubuntu/24.04
make env ENV=containerd/v2.0.3
make env ENV=kubernetes/v1.32.2/containerd/v2.0.3/base
```
### 2.2 Build targets
```bash
make ctr ENV=<env-path>
make vm ENV=<env-path>
make dqd ENV=<env-path>
make dbg ENV=<env-path>
make all ENV=<env-path>
```
Intent:
- `ctr`: build container image for selected env (`build.sh` if present).
- `vm`: convert image to `vm.qcow2` and sparsify.
- `dqd`: build DQD image using generated `vm.qcow2`.
- `dbg`: debug flow with `nokaslr` kernel argument.
- `all`: run `env clean ctr vm dqd push post-clean generate_ssh_config`.
### 2.3 Push and cleanup helpers
```bash
make push-ctr ENV=<env-path>
make push-dqd ENV=<env-path>
make push ENV=<env-path>
make clean ENV=<env-path>
make post-clean ENV=<env-path>
make generate_ssh_config
```
Notes:
- `push` depends on `push-ctr` and `push-dqd`.
- `clean` removes `<ENV>/vm.qcow2`.
- `post-clean` removes `<ENV>/1` after `clean`.
### 2.4 CI entrypoint
```bash
make ci ENV=<env-path>
```
Behavior:
- default: if `CI_MAKE_TARGETS` is unset, CI runs `all`.
- scoped: if `CI_MAKE_TARGETS` is set, CI runs only those targets.
Examples:
```bash
make ci ENV=containerd/v2.0.3
make ci ENV=containerd/v2.0.3 CI_MAKE_TARGETS="ctr"
make ci ENV=runc/v1.2.5 CI_MAKE_TARGETS="clean ctr"
```
### 2.5 Single test execution (important)
There is no in-tree unit-test framework (no pytest/go test/jest).
Use `make ci` with one narrow target as the single-test unit:
```bash
make ci ENV=<env-path> CI_MAKE_TARGETS="<single-target>"
```
Typical single checks:
- build-only: `CI_MAKE_TARGETS="ctr"`
- vm-only: `CI_MAKE_TARGETS="vm"` (requires built image)
- dqd-only: `CI_MAKE_TARGETS="dqd"` (requires `<ENV>/vm.qcow2`)
- cleanup-only: `CI_MAKE_TARGETS="clean"`
### 2.6 Lint/format status
Current repository state:
- no `make lint` target
- no `make fmt` target
- no dedicated standalone unit-test target
Agent policy:
- do not invent non-existent commands
- validate using the smallest real target that covers your change
Optional syntax checks:
```bash
bash -n kubernetes/v1.32.2/containerd/v2.0.3/base/build.sh
bash -n kubernetes/v1.32.2/containerd/v2.0.3/base/pull.sh
sh -n dqd/v0.4.0/start.sh
```
## 3) Runtime commands (docker compose)
```bash
docker compose -f ubuntu/24.04/docker-compose.yml up -d
docker compose -f runc/v1.2.5/docker-compose.yml up -d
docker compose -f containerd/v2.0.3/docker-compose.yml up -d
docker compose -f containerd/v2.0.3/docker-compose.yml -f containerd/v2.0.3/docker-compose.kvm.yml up -d
```
Guideline:
- use `*.kvm.yml` only when `/dev/kvm` exists on host.
## 4) Code style and engineering conventions
### 4.1 Imports/includes/structure
- Shell: keep constants and setup near the top.
- Shell: define helper functions before script entrypoint.
- Dockerfile: group `ARG` blocks (config first, derived/internal next).
- Makefile: reuse shared `define` blocks (`require_env`, `load_env`).
- Keep one responsibility per target/function where practical.
### 4.2 Formatting
- Shell scripts: prefer 4-space indentation in function blocks.
- Makefile recipes: hard tabs only.
- Dockerfile: group related operations for readability.
- Avoid trailing whitespace and mixed indentation.
- Use line continuations for long pipelines/commands.
### 4.3 Types and data handling
- Treat shell env vars as untrusted input.
- Validate required variables before use.
- Use explicit defaults for optional vars (`${VAR:-}`).
- Quote expansions unless deliberate splitting/globbing is required.
- Prefer local variables inside shell functions.
### 4.4 Naming conventions
- Environment variables/constants: `UPPER_SNAKE_CASE`.
- Shell functions: `snake_case`.
- Make targets: short imperative names (`ctr`, `vm`, `dqd`, `clean`).
- Keep versioned path format `name/vX.Y.Z`.
### 4.5 Error handling and robustness
- Prefer strict mode in bash scripts: `set -euo pipefail`.
- Fail fast with clear error messages for missing files/inputs.
- Use `|| true` only for intentionally non-critical operations.
- Include variable/path context in error messages when possible.
### 4.6 Dockerfile rules
- Pin versions with `ARG` and explicit URLs.
- Keep external artifact URLs readable and traceable.
- Clean package manager caches in the same layer.
- Use meaningful stage names (for example `prerequisite`, `install_kube`).
- Minimize layers when it improves reproducibility/readability.
### 4.7 Makefile rules
- Keep `help` output aligned with real behavior.
- Ensure targets that need env use `ENV` validation.
- Keep dependencies explicit and deterministic.
- Do not silently change image tag naming conventions.
## 5) CI workflow conventions
- Workflow file: `.github/workflows/make.yml`.
- Triggers:
  - `push` to `main` when `**/.env` changes
  - `workflow_dispatch` with optional `base_sha` and `head_sha`
- CI detects `VERSION=` changes in `.env` files and builds only impacted env dirs.
- Preserve selective-build behavior when editing workflow logic.
## 6) Cursor/Copilot rule integration
Checked locations:
- `.cursorrules`
- `.cursor/rules/`
- `.github/copilot-instructions.md`
Current status:
- no Cursor rules detected
- no Copilot instructions detected
If these files are added later:
- merge their constraints into this guide
- treat repository-local rule files as higher priority than generic defaults
## 7) Agent checklist
- Read `Makefile` and target `<ENV>/.env` before changing build logic.
- Run `make env ENV=<env-path>` as env-specific preflight.
- Run the narrowest validating command for changed scope.
- Keep docs/examples synchronized with actual behavior.
- Never commit generated artifacts (for example `*.qcow2`).
- Preserve existing image/tag naming unless explicitly requested.
- If you add or change targets, update `make help` text accordingly.
