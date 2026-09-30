# Changelog

Newest first. `scripts/update.sh` prints the new entries when you update.

## 2026-09-30

### Added
- `:EliteHelp` (`<leader>fi`) one-screen guide, `:EliteTutor` practice tutorial, `:EliteEdit options|keymaps|plugins|languages` (creates each personal file from its example and opens it), `:EliteBackup`. New `docs/GETTING_STARTED.md`.
- `:EliteKeys` and `:checkhealth elite` list shipped keys your keymaps replace, remove or delay (prefix clashes); a one-time notice appears at startup when that list changes.
- Safety copies: `install.sh` and `update.sh` save your personal files to `~/.local/state/elite-backups/` first (newest 10 kept). New `scripts/user-layer.sh backup` / `backups`.
- `vim.g.elite_leader_groups` names your own `<leader>` prefixes in which-key and the cheatsheet.
- One-time welcome notice when the config was cloned by hand instead of installed with `scripts/install.sh`; `:checkhealth elite` also reports install state and backups.
- `scripts/install.sh` rewritten: install **alongside** (`nvim-elite`, nothing of yours is touched) or **replace** (`nvim`, old config backed up), plus `--dry-run`, `--clean-data`, `--yes`, `--appname`. Ends with a summary of what happened and how to undo it.
- `scripts/uninstall.sh` (removes the link/launcher, restores your backup), `scripts/update.sh` (shows incoming changes, refuses to overwrite local edits), `scripts/user-layer.sh` (export/import your personal files between machines).
- First launch after install shows a window with the backup location and undo command; `:EliteInfo` shows it again.
- `:checkhealth elite` checks versions, required tools and your personal files.
- Personal layer in `lua/user/` (options, keymaps, plugins), gitignored so updates never conflict. See `docs/MIGRATING.md`.
- `mini.pairs` (auto-close brackets and quotes) and a buffer tabline (via lualine).
- Small comforts: `<Esc>` clears search highlight, `<C-s>` saves, `<leader>q` quits, centered `<C-d>`/`<C-u>`, `J`/`K` move selected lines, visual `p` keeps your register, cursor position restored on reopen, files reload when changed on disk, missing folders created on save, `confirm`/`inccommand`/`winborder`.
- New docs: `docs/INSTALL.md` (every flag, scenario walkthroughs, troubleshooting).

### Changed
- The cheatsheet now lists insert, terminal, command-line, select and operator-pending keys and buffer-local keys, and shows your leader groups and replaced keys.
- toggleterm options are plain `opts`, so they can be changed from `lua/user/plugins/` (for example to rebind `<C-\>`).
- The plugin lockfile is now a personal copy in Neovim's data folder, seeded from `lazy-lock.json`. Adding plugins no longer modifies a tracked file. Maintainers who want to commit it set `vim.g.elite_lockfile_in_repo = true` in `lua/user/options.lua`. `:EliteLockReset` adopts the shipped versions.
- The generated cheatsheet now lives in Neovim's state folder (`:Cheatsheet` opens it), not in `docs/`.
- Only language servers listed in the language table are enabled; servers that merely exist in Mason stay off.
- Arrow keys stay disabled by default; opt out with `vim.g.elite_disable_arrows = false`.
- The update checker no longer pops up notifications; open `:Lazy` to see pending updates.

### Fixed
- `telescope-fzf-native` was built but never loaded.
- Insert-mode `<C-h>` (signature help) removed: many terminals send it for Backspace. Use the built-in `<C-s>`.
- Deprecated APIs replaced (`vim.hl.on_yank`, `vim.uv`, conform `lsp_format`).
- The installer no longer reports Neovim's own freshly created state folder as "old data".
- lazy.nvim no longer prints an error when `lua/user/plugins/` is empty.

### Upgrade notes
- Nothing is required. Run `:EliteHelp` once to see what is new, and `:checkhealth elite` to see your safety copies and key conflicts.
- Delete `docs/cheatsheet.md` if you still have it (it is no longer generated there).
- Run `:Lazy sync` once so `mini.pairs` installs.
- If you commit `lazy-lock.json` yourself, add `vim.g.elite_lockfile_in_repo = true` to `lua/user/options.lua`.
