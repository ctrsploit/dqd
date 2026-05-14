#!/bin/bash
set -e

PROJECT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
SSH_DIR=~/.ssh
KEYS_DIR=${SSH_DIR}/keys
CONFIG_FILE=${SSH_DIR}/config
INCLUDE_CONFIG_PATH="${PROJECT_DIR}/ssh_config/config"
INCLUDE_LINE="Include ${INCLUDE_CONFIG_PATH}"
KEY_FILES=(
  dqd
  dqd_ecdsa-sha2-nistp256
)

mkdir -p "${KEYS_DIR}"
for file in "${KEY_FILES[@]}"; do
  src="${PROJECT_DIR}/ssh_config/${file}"
  dst="${KEYS_DIR}/${file}"
  cp "$src" "$dst"
  chmod 600 "$dst"
done
echo "Installed dqd SSH keys -> ${KEYS_DIR}"

# Ensure the config file exists
touch "${CONFIG_FILE}"

# Prepend the include line if it's not already there
if ! grep -qF -- "${INCLUDE_LINE}" "${CONFIG_FILE}"; then
  TMP_FILE=$(mktemp)
  echo "${INCLUDE_LINE}" > "${TMP_FILE}"
  cat "${CONFIG_FILE}" >> "${TMP_FILE}"
  mv "${TMP_FILE}" "${CONFIG_FILE}"
  echo "Added SSH config include -> ${CONFIG_FILE}"
else
  echo "SSH config include already present -> ${CONFIG_FILE}"
fi

echo "You can now connect with aliases such as: ssh dqd-runc-v1.3.0"
