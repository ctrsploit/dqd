#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
TARGET="${INSTALL_DIR}/dqd"

mkdir -p "$INSTALL_DIR"
ln -sf "${PROJECT_DIR}/bin/dqd" "$TARGET"

echo "Installed dqd -> ${TARGET}"

case ":$PATH:" in
    *":$INSTALL_DIR:"*)
        echo "Run 'rehash' if your shell does not pick up dqd immediately."
        ;;
    *)
        echo
        echo "${INSTALL_DIR} is not in PATH."
        echo "Run this for the current shell:"
        echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
        echo
        echo "To make it persistent in zsh:"
        echo "  echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ~/.zshrc"
        echo "  source ~/.zshrc"
        ;;
esac
