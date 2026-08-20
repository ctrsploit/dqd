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
  # Don't redirect install.sh stdout to /dev/kmsg: prepare (Python) writes
  # to /dev/stdout which breaks with "write /dev/stdout: invalid argument"
  # when stdout is a char device. systemd captures stdout/stderr to the
  # journal; the backgrounded cat /dev/kmsg in the Dockerfile surfaces
  # kmsg to buildkit, and journalctl -u init.service shows the rest.
  ./install.sh
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
