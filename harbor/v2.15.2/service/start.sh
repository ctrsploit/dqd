#!/bin/bash
set -euo pipefail

# Harbor containers use restart: always, but the build-time snapshot captures
# them in stopped state (init.sh calls graceful_exit → docker stop before
# systemctl exit). On VM boot, dockerd starts and tries to restart them, but
# all 8 non-log containers depend on harbor-log's syslog port 127.0.0.1:1514
# for their logging driver. If they start before harbor-log is ready, they
# fail with "dial tcp 127.0.0.1:1514: connect: connection refused" and dockerd
# marks them as failed — restart: always won't retry after a logging-driver
# init failure.
#
# This script ensures harbor-log is up first, then starts the remaining 8
# containers in dependency order via docker compose up -d.

HARBOR_DIR=/harbor-install

log() { echo "[dqd-start] $1"; }

# wait for docker daemon
for i in $(seq 1 30); do
  docker info >/dev/null 2>&1 && break
  sleep 1
done

# start harbor-log first (everything else depends on its syslog port 1514)
log "starting harbor-log..."
docker start harbor-log 2>/dev/null || true

# wait for harbor-log to be healthy (it provides syslog on 127.0.0.1:1514)
for i in $(seq 1 30); do
  if docker inspect harbor-log --format '{{.State.Health.Status}}' 2>/dev/null | grep -q healthy; then
    log "harbor-log healthy"
    break
  fi
  sleep 2
done

# start the remaining 8 containers via docker compose up -d
if [ -f "${HARBOR_DIR}/docker-compose.yml" ]; then
  log "docker compose up -d..."
  cd "${HARBOR_DIR}"
  docker compose up -d 2>&1 || true
  log "done"
else
  log "WARNING: ${HARBOR_DIR}/docker-compose.yml not found"
fi
