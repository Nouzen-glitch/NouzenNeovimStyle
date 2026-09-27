#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "== Neovim Elite Config Installer =="

if ! command -v nvim >/dev/null 2>&1; then
    echo "ERROR: Neovim is not installed."
    exit 1
fi

NVIM_VERSION="$(nvim --version | head -n1)"
echo "Detected: $NVIM_VERSION"

if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: git is required."
    exit 1
fi

if [[ -e "$CONFIG_DIR" ]]; then
    BACKUP="${CONFIG_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Existing config found."
    echo "Backing it up to: $BACKUP"
    mv "$CONFIG_DIR" "$BACKUP"
fi

mkdir -p "$(dirname "$CONFIG_DIR")"
cp -a "$SOURCE_DIR" "$CONFIG_DIR"

# Do not recursively copy the installer directory into itself if the source
# directory happens to already be ~/.config/nvim.
if [[ "$SOURCE_DIR" == "$CONFIG_DIR" ]]; then
    echo "Config is already installed at $CONFIG_DIR."
else
    echo "Installed to $CONFIG_DIR"
fi

echo
echo "Next:"
echo "  nvim"
echo
echo "Then check:"
echo "  :Lazy"
echo "  :Mason"
echo "  :checkhealth"
echo "  :LspInfo"
