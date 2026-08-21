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

# harbor-log runs `sudo -u #10000 -E rsyslogd -n` → PAM → unix_chkpwd →
# needs CAP_DAC_OVERRIDE to read /etc/shadow. On GHA runners the host kernel
# loads an AppArmor "unix-chkpwd" profile (enforce) that denies dac_override.
# This makes sudo fail ("a password is required"), harbor-log crash-loops,
# and install.sh fails.
#
# This ONLY affects the build (the GHA runner kernel has the profile; the
# final VM has its own kernel without it). We run inside the buildkit exec
# container with --security=insecure (all capabilities, unconfined AppArmor),
# which is more privileged than the runner user. Try to disable AppArmor
# entirely or set unix-chkpwd to complain mode. All errors are sent to
# /dev/kmsg so they show in the CI log. No-op when AppArmor is absent
# (local dev). Does NOT modify Harbor containers — this is a kernel-level
# change that only lasts for the duration of the build.
disable_apparmor() {
  log "attempting to disable AppArmor (build-time only)..."
  mountpoint -q /sys/kernel/security 2>/dev/null || \
    mount -t securityfs securityfs /sys/kernel/security 2>/dev/null || true

  if [ ! -d /sys/kernel/security/apparmor ]; then
    log "apparmor not active, skipping"
    return 0
  fi

  log "apparmor profiles (before):"
  cat /sys/kernel/security/apparmor/profiles 2>/dev/kmsg | grep -E 'unix-chkpwd|unix_chkpwd' > /dev/kmsg 2>&1 || \
    log "(no unix-chkpwd profile visible)"

  # Method 1: disable AppArmor entirely (affects only this kernel = build only)
  if [ -f /sys/kernel/security/apparmor/.disable ]; then
    log "trying: echo 1 > .disable"
    if sh -c 'echo 1 > /sys/kernel/security/apparmor/.disable' 2>/dev/kmsg; then
      log "AppArmor disabled via .disable"
      return 0
    fi
    log ".disable failed (error above)"
  fi

  # Method 2: set unix-chkpwd to complain mode (log only, don't deny)
  if [ -f /sys/kernel/security/apparmor/.complain ]; then
    log "trying: echo unix-chkpwd > .complain"
    if sh -c 'echo unix-chkpwd > /sys/kernel/security/apparmor/.complain' 2>/dev/kmsg; then
      log "unix-chkpwd set to complain mode"
      return 0
    fi
    log ".complain failed (error above)"
  fi

  # Method 3: access host securityfs via nsenter (buildkit may share host PID ns)
  if command -v nsenter >/dev/null 2>&1; then
    log "trying: nsenter -t 1 -m (host securityfs)"
    if nsenter -t 1 -m -- sh -c 'echo 1 > /sys/kernel/security/apparmor/.disable' 2>/dev/kmsg; then
      log "AppArmor disabled via nsenter .disable"
      return 0
    fi
    if nsenter -t 1 -m -- sh -c 'echo unix-chkpwd > /sys/kernel/security/apparmor/.complain' 2>/dev/kmsg; then
      log "unix-chkpwd complain via nsenter"
      return 0
    fi
    log "nsenter methods failed (errors above)"
  fi

  log "WARNING: could not disable AppArmor, harbor-log may crash-loop"
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
    log "install.sh failed with exit code ${rc}"
    return "${rc}"
  fi
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
disable_apparmor
install_harbor
wait_harbor_healthy
diagnose
cleanup
sync_data
graceful_exit
