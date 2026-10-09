#!/bin/bash
# Challenge setup for ctf/ghsa-2phj-cp9f-qq6w.
#
# Runs once at VM boot, after the Harbor containers are up:
#   1. wait for Harbor to report healthy OVERALL — the health endpoint's
#      components[] each carry their own "status", and grep'ing for the bare
#      string matches any healthy component long before the deployment is
#      actually ready (v0.1.0 bug: setup raced ahead of database readiness,
#      user creation failed silently). The OVERALL status is the last
#      "status" field in the body.
#   2. create the unprivileged player account and VERIFY it can authenticate
#      (v2.15 rejects API-triggered self-registration, so the account cannot
#      be left to the player). Creation is retried until the login probe
#      succeeds — 409 (exists) and 401 (admin already rotated) are tolerated
#      as intermediate outcomes.
#   3. rotate the stock admin password (Harbor12345 is public knowledge) and
#      VERIFY the stock credentials stop working; retried the same way.
#
# Every step is idempotent: on later boots the attacker login succeeds
# immediately and the stock admin credentials already fail.
set -u

HARBOR=http://127.0.0.1
ADMIN_USER=admin
ADMIN_PASS=Harbor12345
ATTACKER_USER=attacker
ATTACKER_PASS=Attacker12345

log() { echo "[setup-challenge] $1"; }

http_code() { curl -s -o /dev/null -w '%{http_code}' "$@"; }

# 1. wait for Harbor to be healthy overall (first boot runs DB migrations;
#    jobservice is typically the last component to become healthy)
log "waiting for harbor to become healthy..."
for i in $(seq 1 180); do
    st=$(curl -fsSL -m 5 "${HARBOR}/api/v2.0/health" 2>/dev/null | grep -o '"status":"[a-z]*"' | tail -1)
    if [ "${st}" = '"status":"healthy"' ]; then
        log "harbor healthy"
        break
    fi
    if [ "${i}" = "180" ]; then
        log "WARNING: harbor never reported healthy (last: ${st:-none}); continuing"
    fi
    sleep 5
done

# 2. ensure the unprivileged player account exists and can authenticate
log "ensuring harbor user ${ATTACKER_USER} can log in..."
ready=0
for i in $(seq 1 12); do
    if [ "$(http_code -u "${ATTACKER_USER}:${ATTACKER_PASS}" "${HARBOR}/api/v2.0/users/current")" = "200" ]; then
        ready=1
        break
    fi
    code=$(http_code -u "${ADMIN_USER}:${ADMIN_PASS}" -X POST "${HARBOR}/api/v2.0/users" \
        -H 'Content-Type: application/json' \
        -d "{\"username\":\"${ATTACKER_USER}\",\"email\":\"attacker@example.com\",\"realname\":\"attacker\",\"password\":\"${ATTACKER_PASS}\",\"comment\":\"\"}")
    log "user creation attempt ${i} returned ${code} (201 created / 409 exists / 401 admin rotated)"
    sleep 5
done
if [ "${ready}" = "1" ]; then
    log "harbor user ${ATTACKER_USER} ready"
else
    log "WARNING: ${ATTACKER_USER} still cannot log in after retries"
fi

# 3. rotate the stock admin password so only the unprivileged path remains
log "ensuring the stock admin password no longer works..."
rotated=0
for i in $(seq 1 12); do
    if [ "$(http_code -u "${ADMIN_USER}:${ADMIN_PASS}" "${HARBOR}/api/v2.0/users/current")" = "401" ]; then
        rotated=1
        break
    fi
    NEW_ADMIN_PASS="Harbor-$(head -c16 /dev/urandom | od -An -tx1 | tr -d ' \n')"
    code=$(http_code -u "${ADMIN_USER}:${ADMIN_PASS}" -X PUT "${HARBOR}/api/v2.0/users/1" \
        -H 'Content-Type: application/json' \
        -d "{\"password\":\"${NEW_ADMIN_PASS}\"}")
    log "rotation attempt ${i} returned ${code}"
    sleep 2
done
if [ "${rotated}" = "1" ]; then
    log "stock admin password rotated"
else
    log "WARNING: stock admin password still works after retries"
fi

log "done. player account: ${ATTACKER_USER} / ${ATTACKER_PASS}"
log "goal: the secret on http://169.254.169.254/ (only the harbor deployment's egress can reach it)."
