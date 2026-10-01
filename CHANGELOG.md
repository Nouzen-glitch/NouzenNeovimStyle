# Changelog

Newest first. `scripts/update.sh` prints the new entries when you update.

## 2026-10-01

### Added
- **Extras**: opt-in features, all off by default. Enable in `lua/user/options.lua`, for example `vim.g.elite_extras = { "sessions", "dashboard" }`. `:EliteExtras` lists them; unknown names only warn. New `docs/EXTRAS.md`.
  - `sessions` (persistence.nvim): `<leader>ss` restore this folder, `<leader>sl` last session, `<leader>sd` do not save. Never restores by itself.
  - `dashboard` (alpha-nvim): start screen for a bare `nvim` only.
  - `docker`: `<leader>kk` opens lazydocker in a floating terminal (no plugin).
  - `database` (vim-dadbod, vim-dadbod-ui): `<leader>kd`, SQL completion in SQL buffers.
  - `rest`: `<leader>kr` / `:EliteRest` runs the `.http` request under the cursor with curl (built in; kulala.nvim now needs a downloaded binary and the tree-sitter CLI).
  - `dap` (nvim-dap, nvim-dap-ui): `<leader>tb` `tc` `tu` `tx`, `<F5>` `<F9>` `<F10>` `<F11>` `<S-F11>`; Mason installs debugpy, codelldb and js-debug-adapter. Extra adapters via `User EliteDapSetup`.
- `:checkhealth elite` has an extras section (missing tools are warnings).
- WSL 2 is documented as the way to use this config on Windows.

### Fixed
- `lazy-lock.json` now lists `mini.pairs` and the extras' plugins.

### Upgrade notes
- Nothing is required: with `vim.g.elite_extras` unset nothing changes.
- To use an extra, add it to `vim.g.elite_extras` in `lua/user/options.lua` and restart; new plugins install automatically. Run `:checkhealth elite` for missing tools.
- If you commit `lazy-lock.json` yourself (`vim.g.elite_lockfile_in_repo = true`), run `:Lazy` once with the extras you want and commit it.

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

### Fixed (follow-up)
- `scripts/user-layer.sh`: relative paths (`export mine.tgz`, `import mine.tgz`, and the default archive name) now resolve from the folder you ran it in, not the repo. This also fixes `:EliteBackup name.tgz`.
- `:` and `/` completion works before you first enter Insert mode (nvim-cmp now also loads on `CmdlineEnter`).
- The "keys replaced" startup notice is no longer marked as seen by headless runs (smoke test, cheatsheet watcher).
- Terminal keys (`jk`, `<Esc>`, `<C-h/j/k/l>`) apply only to the toggleterm terminal, so TUIs such as lazygit or fzf keep them.
- `--help` in `update.sh`, `uninstall.sh` and `user-layer.sh` no longer prints the `set -euo pipefail` line; `uninstall.sh --dry-run` no longer claims it restored or removed anything; `smoke-test.sh` detects an alongside install.
- Docs: terminal-mode key caveats, `lua_ls` override note and new maintainer gotchas.
- Arrow-key `<Nop>` maps have a `desc`; `<leader>e` is no longer also declared as a which-key group.

### Upgrade notes
- Nothing is required. Run `:EliteHelp` once to see what is new, and `:checkhealth elite` to see your safety copies and key conflicts.
- Delete `docs/cheatsheet.md` if you still have it (it is no longer generated there).
- Restart Neovim: `mini.pairs` installs automatically (watch `:Lazy`).
- If you commit `lazy-lock.json` yourself, add `vim.g.elite_lockfile_in_repo = true` to `lua/user/options.lua`.
