#!/bin/bash
set -e

HARBOR_VERSION=2.15.2
INSTALL_DIR=/harbor-install

# idempotent: skip if Harbor is already up (e.g. reboot after first install)
if docker ps --format '{{.Names}}' | grep -q '^harbor-'; then
    echo "[harbor-init] Harbor containers already running, skipping install."
    exit 0
fi

echo "[harbor-init] waiting for docker daemon..."
for i in $(seq 1 60); do
    if docker info >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

echo "[harbor-init] downloading harbor offline installer v${HARBOR_VERSION}..."
mkdir -p ${INSTALL_DIR}
curl -fsSL -o ${INSTALL_DIR}/harbor-offline-installer-v${HARBOR_VERSION}.tgz \
    https://github.com/goharbor/harbor/releases/download/v${HARBOR_VERSION}/harbor-offline-installer-v${HARBOR_VERSION}.tgz

echo "[harbor-init] extracting..."
tar -xzf ${INSTALL_DIR}/harbor-offline-installer-v${HARBOR_VERSION}.tgz -C ${INSTALL_DIR} --strip-components=1

cd ${INSTALL_DIR}

# official default deployment: only set hostname (install.sh requires a non-localhost
# hostname, but 127.0.0.1 satisfies the check and keeps the env self-contained).
# All other settings stay at template defaults: port 80, admin Harbor12345,
# project_creation_restriction everyone, no https/proxy/internal_tls.
echo "[harbor-init] configuring harbor.yml (hostname: 127.0.0.1, all else template defaults)..."
sed -i 's/^hostname: .*/hostname: 127.0.0.1/' harbor.yml

echo "[harbor-init] running official install.sh..."
./install.sh

echo "[harbor-init] waiting for Harbor to become healthy..."
for i in $(seq 1 120); do
    status=$(curl -fsSL -o /dev/null -w "%{http_code}" http://127.0.0.1/api/v2.0/health 2>/dev/null || echo "000")
    if [ "${status}" = "200" ]; then
        echo "[harbor-init] Harbor health endpoint returned 200"
        break
    fi
    sleep 2
done

echo "[harbor-init] Harbor containers:"
docker ps --format '{{.Names}}\t{{.Status}}' | sort

echo "[harbor-init] cleaning up installer archive..."
rm -f ${INSTALL_DIR}/harbor-offline-installer-v${HARBOR_VERSION}.tgz

echo "[harbor-init] done."
