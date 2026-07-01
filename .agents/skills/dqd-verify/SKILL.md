---
name: dqd-verify
description: Use when the user asks to update README versions output, verify runtime output, fill in <!-- VERIFY --> placeholders, or "更新README"/"验证版本"/"补全输出"/"verify outputs".
---

# dqd Verify

Use this skill when the user asks to fill in runtime-dependent output in README files. Do NOT use during initial environment migration — that is `dqd-dev` work.

## Prerequisite

The environment must be running (via `docker compose up -d`) and accessible via SSH. The README must contain `<!-- VERIFY -->` placeholder comments.

Branch and commit scope:
- README verification commits may be made directly on `main`.
- Do not create a migration branch solely for README verification unless the user asks.
- The commit must include only `<ENV>/README.md`; leave unrelated files such as `.reasonix/` untouched.

## Workflow

### 1. Parse targets

Find all `<!-- VERIFY -->` placeholders and extract the command above each:

```bash
grep -B1 '<!-- VERIFY -->' <ENV>/README.md
```

The line immediately above `<!-- VERIFY -->` is the expected prompt line in the format:
`root@<hostname>:~# <command>`

Extract `<command>` from that line.

### 2. Start environment if needed

```bash
docker compose -f <ENV>/docker-compose.yml -f <ENV>/docker-compose.kvm.yml up -d
```

Wait for SSH to become available.

### 3. Execute commands and capture output

For each extracted command, run it inside the environment:

```bash
ssh dqd-<image-name> "<extracted-command>"
```

Capture the full output. The SSH host alias uses the image name from `<ENV>/.env` with a `dqd-` prefix. For example, if `IMAGE=runc-v0.1.1`, the SSH host is `dqd-runc-v0.1.1`.

### 4. Replace placeholders

Replace each `<!-- VERIFY -->` line with the captured output.

Before:
```shell
root@runc-0-1-1:~# runc --version
<!-- VERIFY -->
root@runc-0-1-1:~# uname -a
<!-- VERIFY -->
```

After:
```shell
root@runc-0-1-1:~# runc --version
runc version 0.1.1
commit: bf8860ae...
spec: 0.5.0
root@runc-0-1-1:~# uname -a
Linux runc-0-1-1 4.4.0-210-generic ...
```

Edge cases:
- Multi-line output: keep all lines as-is.
- Command with no output (e.g., `uname` with no args): still replace with a blank line.
- Trailing whitespace from captured output: trim.
- The `<!-- VERIFY -->` must be on its own line; do NOT append output after it inline.

### 5. Confirm no remaining placeholders

```bash
grep '<!-- VERIFY -->' <ENV>/README.md
```

Must return nothing.

Also check for stale placeholder text and SSH noise:

```bash
grep -E '<!-- VERIFY -->|<container-id>|Warning: Permanently added' <ENV>/README.md
```

Must return nothing.

### 6. Commit

```bash
git add <ENV>/README.md
git diff --cached --name-status
git diff --cached --check
git commit -m "verify <ENV>: fill version output"
```

Before committing, verify `git diff --cached --name-status` lists only `<ENV>/README.md`.

### 8. Multi-session exploits (server + victim)

Some reproduce sections require a server running in one session while a victim action happens in another (e.g., malicious OCI registry + `docker compose up`). Use `run_background` + `run_command`:

```bash
# Session 1: start the server (keeps running)
run_background "ssh ... 'ctrsploit vul XXXX x'"

# Session 2: trigger the victim action
run_command "ssh ... 'docker compose up'"
```

Key points:
- `run_background` keeps the SSH session alive even after the command starts producing output.
- The server's output can be monitored via `job_output`.
- Use `stop_job` to cleanly terminate the server afterward.
- For exploit commands that overwrite a file, the file write is the verification marker (e.g., `cat /tmp/pwnd`).

### 9. Interactive exploit shells

Some reproduce sections involve commands that drop into an interactive shell (e.g., `ctrsploit exploit`). Use `printf` with `docker run -i` to pipe commands in:

```bash
printf "grep CapEff /proc/self/status\ngrep Seccomp /proc/self/status\nexit\n" | \
  docker run -i --rm --net=host <image> sh -c "... ctrsploit exploit -t"
```

Key points:
- `docker run -i` (not `-ti`) enables stdin pipe without TTY.
- End with `exit\n` to cleanly terminate the shell.
- Use `timeout` if the exploit may hang waiting for conditions that don't apply (e.g., `timeout 5`).
- For multi-command sequences, separate with `\n` in the printf string.

### 10. Stop environment

```bash
docker compose -f <ENV>/docker-compose.yml down
```

After stopping, report the branch name, commit hash, and that only `<ENV>/README.md` was committed.
