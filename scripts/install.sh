#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

echo "== Neovim Elite Config Installer =="

command -v nvim >/dev/null 2>&1 || { echo "ERROR: Neovim is not installed."; exit 1; }
command -v git  >/dev/null 2>&1 || { echo "ERROR: git is required."; exit 1; }
echo "Detected: $(nvim --version | head -n1)"

if [[ -L "$CONFIG_DIR" && "$(readlink -f "$CONFIG_DIR")" == "$SOURCE_DIR" ]]; then
    echo "Already installed: $CONFIG_DIR -> $SOURCE_DIR"
    exit 0
fi

if [[ -e "$CONFIG_DIR" || -L "$CONFIG_DIR" ]]; then
    BACKUP="${CONFIG_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing config to: $BACKUP"
    mv "$CONFIG_DIR" "$BACKUP"
fi

mkdir -p "$(dirname "$CONFIG_DIR")"
ln -s "$SOURCE_DIR" "$CONFIG_DIR"
echo "Linked $CONFIG_DIR -> $SOURCE_DIR"
echo
echo "Next: run nvim, then check :Lazy :Mason :checkhealth :LspInfo"
