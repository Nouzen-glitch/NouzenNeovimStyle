# Changelog

Newest first. `scripts/update.sh` prints the new entries when you update.

## 2026-09-30

### Added
- `scripts/install.sh` rewritten: install **alongside** (`nvim-elite`, nothing of yours is touched) or **replace** (`nvim`, old config backed up), plus `--dry-run`, `--clean-data`, `--yes`, `--appname`. Ends with a summary of what happened and how to undo it.
- `scripts/uninstall.sh` (removes the link/launcher, restores your backup), `scripts/update.sh` (shows incoming changes, refuses to overwrite local edits), `scripts/user-layer.sh` (export/import your personal files between machines).
- First launch after install shows a window with the backup location and undo command; `:EliteInfo` shows it again.
- `:checkhealth elite` checks versions, required tools and your personal files.
- Personal layer in `lua/user/` (options, keymaps, plugins), gitignored so updates never conflict. See `docs/MIGRATING.md`.
- `mini.pairs` (auto-close brackets and quotes) and a buffer tabline (via lualine).
- Small comforts: `<Esc>` clears search highlight, `<C-s>` saves, `<leader>q` quits, centered `<C-d>`/`<C-u>`, `J`/`K` move selected lines, visual `p` keeps your register, cursor position restored on reopen, files reload when changed on disk, missing folders created on save, `confirm`/`inccommand`/`winborder`.
- New docs: `docs/INSTALL.md` (every flag, scenario walkthroughs, troubleshooting).

### Changed
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
- Delete `docs/cheatsheet.md` if you still have it (it is no longer generated there).
- Run `:Lazy sync` once so `mini.pairs` installs.
- If you commit `lazy-lock.json` yourself, add `vim.g.elite_lockfile_in_repo = true` to `lua/user/options.lua`.
