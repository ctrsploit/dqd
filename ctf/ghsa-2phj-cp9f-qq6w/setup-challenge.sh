#!/bin/bash
# Challenge setup for ctf/ghsa-2phj-cp9f-qq6w.
#
# Runs once at VM boot, after the Harbor containers are up:
#   1. wait for Harbor to report healthy (DB migrations can take minutes)
#   2. create the unprivileged player account (v2.15 rejects API-triggered
#      self-registration, so the account cannot be left to the player)
#   3. rotate the stock admin password (Harbor12345 is public knowledge;
#      best-effort — 401s on every later boot once rotated)
#
# Every step is idempotent: on later boots the user exists (409) and the
# stock admin credentials no longer work (401), both are tolerated.
set -u

HARBOR=http://127.0.0.1
ADMIN_USER=admin
ADMIN_PASS=Harbor12345
ATTACKER_USER=attacker
ATTACKER_PASS=Attacker12345

log() { echo "[setup-challenge] $1"; }

# 1. wait for Harbor to be healthy (first boot runs DB migrations)
log "waiting for harbor to become healthy..."
for i in $(seq 1 120); do
    if curl -fsSL "${HARBOR}/api/v2.0/health" 2>/dev/null | grep -q '"status":"healthy"'; then
        log "harbor healthy"
        break
    fi
    sleep 5
done

# 2. create the unprivileged player account (idempotent)
code=$(curl -s -o /dev/null -w '%{http_code}' \
    -u "${ADMIN_USER}:${ADMIN_PASS}" -X POST "${HARBOR}/api/v2.0/users" \
    -H 'Content-Type: application/json' \
    -d "{\"username\":\"${ATTACKER_USER}\",\"email\":\"attacker@example.com\",\"realname\":\"attacker\",\"password\":\"${ATTACKER_PASS}\",\"comment\":\"\"}")
case "${code}" in
    201) log "created harbor user ${ATTACKER_USER}" ;;
    409) log "harbor user ${ATTACKER_USER} already exists" ;;
    *)   log "harbor user creation returned ${code} (tolerated: exists-or-rotated)" ;;
esac

# 3. rotate the stock admin password so only the unprivileged path remains
NEW_ADMIN_PASS="Harbor-$(head -c16 /dev/urandom | od -An -tx1 | tr -d ' \n')"
code=$(curl -s -o /dev/null -w '%{http_code}' \
    -u "${ADMIN_USER}:${ADMIN_PASS}" -X PUT "${HARBOR}/api/v2.0/users/1" \
    -H 'Content-Type: application/json' \
    -d "{\"password\":\"${NEW_ADMIN_PASS}\"}")
case "${code}" in
    200) log "rotated the stock admin password" ;;
    *)   log "admin password rotation returned ${code} (tolerated: already rotated)" ;;
esac

log "done. player account: ${ATTACKER_USER} / ${ATTACKER_PASS}"
log "goal: the secret on http://169.254.169.254/ (only the harbor deployment's egress can reach it)."
