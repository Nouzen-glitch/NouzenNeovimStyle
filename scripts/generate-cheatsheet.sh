#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
nvim --headless "+lua require('util.cheatsheet').generate()" "+qa"
