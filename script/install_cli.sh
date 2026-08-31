#!/usr/bin/env bash
set -euo pipefail

# DEPRECATED: `dqd` is installable without a checkout via
#   go install github.com/ctrsploit/dqd/cli/cmd/dqd@latest
# or from GitHub releases (cli-v* tags). This script only symlinks a
# locally built binary and will be removed.
echo "dqd: WARNING: script/install_cli.sh is deprecated; prefer:" >&2
echo "dqd:          go install github.com/ctrsploit/dqd/cli/cmd/dqd@latest" >&2

PROJECT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
TARGET="${INSTALL_DIR}/dqd"

# The `dqd` command is the Go CLI; build it first if needed.
if [ ! -x "${PROJECT_DIR}/bin/dqd" ]; then
    echo "bin/dqd not built yet; run: make cli" >&2
    exit 1
fi

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
