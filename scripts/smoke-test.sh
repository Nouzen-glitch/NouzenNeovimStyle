#!/usr/bin/env bash
# Quick check that the Elite modules load and the generators run (headless).
# Uses your active config (pass NVIM_APPNAME=elite for an alongside install).
#   scripts/smoke-test.sh
set -euo pipefail
cd "$(dirname "$0")/.."
REPO="$(pwd -P)"

# Alongside install: use it unless the caller already chose one.
if [[ -z "${NVIM_APPNAME:-}" ]]; then
    config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    for name in elite nvim; do
        link="$config_home/$name"
        if [[ -e "$link" && "$(readlink -f "$link")" == "$REPO" ]]; then
            [[ "$name" == "nvim" ]] || export NVIM_APPNAME="$name"
            break
        fi
    done
fi

nvim --headless \
  "+lua for _, m in ipairs({'util.keyguard','util.guide','util.welcome','util.cheatsheet','config.leader_groups','util.extras','elite.health'}) do assert(pcall(require, m), 'failed to load ' .. m) end" \
  "+lua assert(#require('util.guide').help_lines() > 0 and #require('util.guide').tutor_lines() > 0)" \
  "+lua print('keys: ' .. table.concat(require('util.keyguard').report_lines(), ' | '))" \
  "+lua print('cheatsheet: ' .. require('util.cheatsheet').generate())" \
  "+qa" 2>&1
echo "Smoke test finished. Now open nvim and try :EliteHelp, :EliteKeys, :EliteTutor, :checkhealth elite"
