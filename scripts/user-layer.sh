#!/usr/bin/env bash
# Carry your personal layer between machines (or keep a backup of it).
#
#   scripts/user-layer.sh list                  show which personal files exist
#   scripts/user-layer.sh export [FILE]         pack them (default: ./elite-user-layer-<date>.tar.gz)
#   scripts/user-layer.sh import FILE           unpack onto this machine
#
# "Personal layer" means lua/user/*.lua, lua/user/plugins/*.lua and
# lua/config/languages_local.lua. The *.example files are not included.
# Existing files are moved aside (name.bak.<timestamp>) before import overwrites them.
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$SOURCE_DIR"

say() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

collect() {
    {
        find lua/user -type f ! -name '*.example' ! -name '.gitkeep' ! -name '*.bak.*' 2>/dev/null
        if [[ -f lua/config/languages_local.lua ]]; then echo lua/config/languages_local.lua; fi
    } | sort
}

usage() { sed -n '2,10p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; }

cmd="${1:-}"
[[ -n "$cmd" ]] || { usage; exit 1; }
shift || true

case "$cmd" in
    list)
        files="$(collect)"
        if [[ -z "$files" ]]; then
            say "No personal files yet. See docs/MIGRATING.md and the *.example files in lua/user/."
        else
            say "Personal files:"
            printf '%s\n' "$files" | sed 's/^/  /'
        fi
        ;;

    export)
        files="$(collect)"
        [[ -n "$files" ]] || die "Nothing to export: no personal files found."
        out="${1:-$PWD/elite-user-layer-$(date +%Y%m%d).tar.gz}"
        printf '%s\n' "$files" | tar czf "$out" -T -
        say "Exported to: $out"
        printf '%s\n' "$files" | sed 's/^/  /'
        say
        say "Check the files for secrets (tokens, private paths) before sharing the archive."
        say "On the other machine: scripts/user-layer.sh import <archive>"
        ;;

    import)
        archive="${1:-}"
        [[ -n "$archive" && -f "$archive" ]] || die "Give the archive to import: scripts/user-layer.sh import FILE"
        entries="$(tar tzf "$archive")" || die "Not a valid archive: $archive"
        while IFS= read -r e; do
            case "$e" in
                /*|*..*) die "Refusing archive with unsafe path: $e" ;;
                lua/user/*|lua/config/languages_local.lua) ;;
                *) die "Refusing archive with unexpected file: $e (only lua/user/ and languages_local.lua are allowed)" ;;
            esac
        done <<<"$entries"

        stamp="$(date +%Y%m%d-%H%M%S)"
        while IFS= read -r e; do
            [[ "$e" == */ ]] && continue
            if [[ -f "$e" ]]; then
                mv "$e" "$e.bak.$stamp"
                say "Moved aside: $e -> $e.bak.$stamp"
            fi
        done <<<"$entries"
        tar xzf "$archive"
        say "Imported:"
        printf '%s\n' "$entries" | grep -v '/$' | sed 's/^/  /'
        say
        say "Restart Neovim, then run :checkhealth elite."
        ;;

    -h|--help|help) usage ;;
    *) usage; die "Unknown command: $cmd" ;;
esac
