#!/bin/bash
set -euo pipefail

HARBOR_VERSION=2.15.2
INSTALL_DIR=/harbor-install

log() {
  echo "[dqd] $1" > /dev/kmsg
}

fail_exit() {
  local exit_code=$?
  log "Harbor init failed with exit code ${exit_code}"
  diagnose
  # Stop restart:always containers before systemctl exit, same as
  # graceful_exit — otherwise dockerd races with the stop policy and
  # deadlocks systemd shutdown, hanging the build until CI timeout.
  docker stop $(docker ps -q) 2>/dev/null || true
  sync
  systemctl --force exit "${exit_code}"
}

trap fail_exit ERR

wait_docker() {
  log "waiting for docker daemon..."
  for i in $(seq 1 60); do
    if docker info >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done
  log "docker daemon ready"
}

install_harbor() {
  log "downloading harbor offline installer v${HARBOR_VERSION}..."
  mkdir -p ${INSTALL_DIR}
  curl -fsSL -o ${INSTALL_DIR}/harbor-offline-installer-v${HARBOR_VERSION}.tgz \
    https://github.com/goharbor/harbor/releases/download/v${HARBOR_VERSION}/harbor-offline-installer-v${HARBOR_VERSION}.tgz

  log "extracting..."
  tar -xzf ${INSTALL_DIR}/harbor-offline-installer-v${HARBOR_VERSION}.tgz -C ${INSTALL_DIR} --strip-components=1

  cd ${INSTALL_DIR}

  # offline installer ships harbor.yml.tmpl only; install.sh/prepare need harbor.yml
  cp harbor.yml.tmpl harbor.yml

  # official default deployment (http only, no https):
  # - hostname: harbor.local (prepare rejects 127.0.0.1/localhost)
  # - comment out the https block: the template ships https with placeholder
  #   cert paths (/your/certificate/path), which prepare rejects with
  #   "The protocol is https but attribute ssl_cert is not set". The official
  #   http-only default is to remove the https block entirely.
  # All other settings stay at template defaults: port 80, admin Harbor12345,
  # project_creation_restriction everyone, no proxy/internal_tls.
  log "configuring harbor.yml (hostname: harbor.local, http only)..."
  sed -i 's/^hostname: .*/hostname: harbor.local/' harbor.yml
  # remove the https block (template ships placeholder cert paths that
  # prepare rejects); keep the comment header for readability
  sed -i '/^https:/,/^[^ #]/{/^https:/d; /^[^ #]/!d}' harbor.yml

  log "running official install.sh..."
  # Surface install.sh stdout/stderr to CI by teeing to /dev/kmsg.
  # We use a pipe (not a direct > /dev/kmsg redirect) so prepare's Python
  # /dev/stdout sees a FIFO, not the /dev/kmsg char device — direct redirect
  # causes "write /dev/stdout: invalid argument" inside prepare.
  # Disable set -e around the pipeline so we can capture PIPESTATUS and log
  # the real exit code instead of having bash exit silently (the ERR trap
  # proved unreliable in this systemd-in-buildkit context).
  set +e
  ./install.sh 2>&1 | tee /dev/kmsg
  local rc=${PIPESTATUS[0]}
  set -e
  if [ "${rc}" -ne 0 ]; then
    log "install.sh failed with exit code ${rc}, trying /etc/shadow fix..."
    fix_shadow_permissions
    log "restarting docker compose after shadow fix..."
    set +e
    docker compose up -d 2>&1 | tee /dev/kmsg
    rc=${PIPESTATUS[0]}
    set -e
    if [ "${rc}" -eq 0 ]; then
      log "compose up succeeded after shadow fix"
    else
      log "compose up still failed after shadow fix (rc=${rc})"
      return "${rc}"
    fi
  fi
}

# harbor-log runs `sudo -u #10000 -E rsyslogd -n` → PAM → unix_chkpwd →
# needs CAP_DAC_OVERRIDE to read /etc/shadow. On GHA runners the host kernel
# loads an AppArmor "unix-chkpwd" profile (enforce) that denies dac_override,
# and the profile CANNOT be neutralized from userspace (not even with sudo —
# the runner's AppArmor is locked down). This makes sudo fail ("a password is
# required"), harbor-log exits 1, and install.sh fails.
#
# Fix: make /etc/shadow world-readable (chmod 644) inside each container.
# unix_chkpwd drops EUID to the calling user before reading /etc/shadow, so
# it needs dac_override to read a root-owned mode-640 file. With mode 644,
# the file is DAC-readable by any UID — no dac_override needed, and the
# AppArmor denial becomes irrelevant. This is a build-time-only fix (the
# image is for vul reproduction, not production).
fix_shadow_permissions() {
  log "stopping all containers for /etc/shadow fix..."
  docker stop $(docker ps -q) 2>/dev/null || true
  log "chmod 644 /etc/shadow in all containers..."
  for c in $(docker ps -a --format '{{.Names}}' 2>/dev/null); do
    docker cp "$c:/etc/shadow" /tmp/shadow_fix 2>/dev/null || continue
    chmod 644 /tmp/shadow_fix
    docker cp /tmp/shadow_fix "$c:/etc/shadow" 2>/dev/null || true
    rm -f /tmp/shadow_fix
    log "fixed /etc/shadow in ${c}"
  done
}

wait_harbor_healthy() {
  log "waiting for Harbor to become healthy..."
  local healthy=false
  for i in $(seq 1 120); do
    status=$(curl -fsSL -o /dev/null -w "%{http_code}" http://127.0.0.1/api/v2.0/health 2>/dev/null || echo "000")
    if [ "${status}" = "200" ]; then
      log "Harbor health endpoint returned 200"
      healthy=true
      break
    fi
    sleep 2
  done
  if [ "${healthy}" = false ]; then
    log "WARNING: Harbor did not become healthy within 240s"
  fi
}

diagnose() {
  log "=== DIAGNOSE: docker ps -a ==="
  docker ps -a --format '{{.Names}}\t{{.Status}}\t{{.Image}}' > /dev/kmsg 2>&1
  log "=== DIAGNOSE: container logs (last 10 lines each) ==="
  for c in $(docker ps -a --format '{{.Names}}' 2>/dev/null); do
    echo "--- ${c} ---" > /dev/kmsg 2>&1
    docker logs --tail 10 "${c}" > /dev/kmsg 2>&1
  done
  log "=== DIAGNOSE: docker compose ps ==="
  cd ${INSTALL_DIR} 2>/dev/null && docker compose ps > /dev/kmsg 2>&1 || true
  log "=== DIAGNOSE: journalctl init.service (last 80 lines) ==="
  journalctl -u init.service --no-pager -n 80 > /dev/kmsg 2>&1 || true
  log "=== DIAGNOSE done ==="
}

cleanup() {
  log "removing installer archive..."
  rm -f ${INSTALL_DIR}/harbor-offline-installer-v${HARBOR_VERSION}.tgz
}

sync_data() {
  log "syncing data to prevent data loss"
  sync
  log "data synced"
}

graceful_exit() {
  log "stopping all docker containers (prevent restart: always from blocking systemd shutdown)..."
  # Harbor containers use restart: always. When systemctl exit 0 stops
  # docker.service, dockerd tries to stop containers but restart: always
  # races with the stop, deadlocking systemd shutdown. Stop them first.
  docker stop $(docker ps -q) 2>/dev/null || true
  log "containers stopped"
  log "gracefully exiting systemd"
  systemctl exit 0
}

wait_docker
install_harbor
wait_harbor_healthy
diagnose
cleanup
sync_data
graceful_exit
