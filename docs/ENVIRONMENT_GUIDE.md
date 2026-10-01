# Environment Guide

How to maintain this configuration. For install steps see
[INSTALL.md](INSTALL.md); for keys see [KEYBINDINGS.md](KEYBINDINGS.md); for
customizing and bringing your own config see [MIGRATING.md](MIGRATING.md).

## 1. Source vs active config

Master copy: wherever you cloned the repo (examples use `~/dotfiles/nvim/`).
Neovim loads `~/.config/nvim/` (replace mode) or `~/.config/elite/`
(alongside mode). `scripts/install.sh` makes that a symlink to the repo so
there is exactly one copy (see [INSTALL.md](INSTALL.md) for both modes):

```text
~/dotfiles/nvim  <---  ~/.config/nvim (symlink)  --->  Neovim
```

Plugin installs, cache, and state live elsewhere
(`~/.local/share|state|cache/nvim`, or `.../elite` when installed alongside).
Never edit plugin sources; updates overwrite them.

## 2. How loading works

```text
init.lua
 ├─ config.options
 ├─ user.options         (yours, optional)
 ├─ config.keymaps
 ├─ user.keymaps         (yours, optional)
 │                       (config.keymaps is followed by util.extras.keymaps(): keys of enabled extras)
 ├─ config.autocmds
 ├─ config.lazy ──► lazy.nvim ──► plugins/*.lua, extras/<name>.lua for each name in
 │                  vim.g.elite_extras, then user/plugins/*.lua
 │                  (lockfile path from util.lockfile; user/plugins only
 │                   imported once it contains a .lua file)
 ├─ util.cheatsheet.setup()
 ├─ util.lockfile.setup()      :EliteLockReset
 ├─ util.welcome.setup()       first-run window, :EliteInfo
 ├─ util.guide.setup()         :EliteHelp, :EliteTutor, :EliteEdit, :EliteBackup
 ├─ util.extras.setup()        commands of enabled extras (:EliteRest)
 └─ util.keyguard.setup()      :EliteKeys, one-time "keys replaced" notice
```

`init.lua` runs `config.keymaps` and `user.keymaps` through
`util.keyguard.track_shipped()` / `track_user()`. While they load,
`vim.keymap.set` and `vim.keymap.del` are wrapped (the real call always still
runs) so shipped keys, replacements, removals and prefix clashes are recorded.
The result feeds `:EliteKeys`, `:checkhealth elite`, the cheatsheet and a
one-time startup notice (state file `elite-keys-seen`).

## 3. Everyday workflow

1. Pick the file (table in README).
2. Edit, restart Neovim.
3. Test: `scripts/smoke-test.sh` loads every Elite module headless and prints
   the key-conflict report (use `NVIM_APPNAME=elite` for an alongside install).
   Then try the change for real. If good, `git add . && git commit -m "..."`.
   If broken, `git restore`.

Personal files under `lua/user/` and `lua/config/languages_local.lua` are
gitignored.

**Lockfile.** Each user's plugin versions live in a personal copy
(`stdpath("data")/elite-lazy-lock.json`), seeded from the repo's
`lazy-lock.json`, so users' changes never dirty the repo. As the maintainer,
set `vim.g.elite_lockfile_in_repo = true` in your own `lua/user/options.lua`;
lazy then reads and writes the repo's `lazy-lock.json`, which you commit so
new installs get reproducible versions. Note the setting only affects the
machine you set it on.

**Releasing.** Add an entry to `CHANGELOG.md` for user-visible changes; the
new lines are what `scripts/update.sh` shows users. Mention anything they must
do (for example "run `:EliteLockReset`") under "Upgrade notes".

## 4. Plugins

- **Add:** new spec in `lua/plugins/` (new file or an existing related one);
  lazy.nvim installs on next start. For yourself only, use `lua/user/plugins/`.
- **Remove:** delete the spec, then `:Lazy clean`.
- **Update:** `:Lazy update` (or `U` in `:Lazy`). With
  `vim.g.elite_lockfile_in_repo = true`, commit the lockfile afterwards.
  The background update checker is silent; open `:Lazy` to see what is pending.
- **Updating the config itself:** `scripts/update.sh` (see [INSTALL.md](INSTALL.md)).
- **Change:** edit its spec; restart while learning.

## 5. Adding a language

Add one line to `lua/config/languages_local.lua` (or `languages.lua` for a new
default) and restart. The server, parser,
formatter and formatter tools are derived from it and installed
automatically. Full guide: [ADDING_LANGUAGES.md](ADDING_LANGUAGES.md).

## 6. Useful commands

| Command | Use |
| --- | --- |
| `:Lazy` | Plugin manager |
| `:Mason` | Servers and tools |
| `:checkhealth elite` | Versions, required tools, install state, lockfile mode, your `user/` files |
| `:EliteInfo` | How this config was installed and where any backup is |
| `:EliteLockReset` | Replace your personal lockfile with the shipped one (then restart, `:Lazy restore`) |
| `:checkhealth vim.lsp` | Servers attached to current buffer |
| `:MasonToolsInstall` | Install any missing formatters/tools from the language table |
| `:ConformInfo` | Formatter status |
| `:TSUpdate` | Update parsers |
| `:checkhealth` | Diagnose everything |
| `:EliteHelp` / `:EliteTutor` | One-screen guide / practice tutorial |
| `:EliteEdit {options,keymaps,plugins,languages}` | Create and open a personal file |
| `:EliteKeys` | Shipped keys the user's keymaps replaced |
| `:EliteBackup [file]` | Export personal files |
| `:EliteExtras` | Opt-in extras and which are enabled |

## 7. Cheatsheet automation

The cheatsheet is generated by `util/cheatsheet.lua` from the live
environment (keymaps, user commands, versions, attached LSPs). Never edit it.
It is written to `stdpath("state")/cheatsheet.md` (for example
`~/.local/state/nvim/cheatsheet.md`), **not** into the repo: it contains
machine-specific paths and changes on every start, which would keep git dirty.

It regenerates:

- on every Neovim start, and after `:Lazy` finishes (`LazyDone`)
- when you save any `.lua` file inside the config
- on demand: `:Cheatsheet` (regenerate and open), `:CheatsheetUpdate`
- headless: `scripts/generate-cheatsheet.sh` (follows an alongside install
  automatically)
- via systemd (optional, below)

Headless runs only see keymaps of plugins that are loaded, so the
"8 loaded / 28 total" count and missing lazy-loaded keys are expected. LSP
clients are only listed if attached when it was generated.

### Optional: systemd watcher

The unit files assume the repo is at `~/dotfiles/nvim`. If you cloned it
elsewhere, edit the paths in `systemd/cheatsheet-watch.*` after copying.

```bash
mkdir -p ~/.config/systemd/user
cp ~/dotfiles/nvim/systemd/cheatsheet-watch.* ~/.config/systemd/user/
chmod +x ~/dotfiles/nvim/scripts/generate-cheatsheet.sh
systemctl --user daemon-reload
systemctl --user enable --now cheatsheet-watch.path
```

`PathChanged` watches only the direct contents of `~/dotfiles/nvim`, not
`lua/` subfolders. Saves inside Neovim are already covered by the autocmd, so
the watcher mainly helps with edits made outside Neovim to top-level files.

## 8. Gotchas

| Topic | Detail |
| --- | --- |
| Symlinked config path | Neovim does not resolve symlinks in buffer names. `lsp.lua` and `util/cheatsheet.lua` compare paths using `fs_realpath`, so editing via `~/dotfiles/nvim/...` or `~/.config/nvim/...` behaves the same. Keep that if you edit them |
| Alongside installs | Everything uses `stdpath()`, which follows `NVIM_APPNAME`. Never hardcode `~/.config/nvim` in Lua |
| `lua_ls` scope | Attaches only to files inside the Neovim config. Widening `root_dir` means editing the shipped `plugins/lsp.lua`, so it is a maintainer change: users who do it make `scripts/update.sh` stop until they stash or commit. A `vim.lsp.config("lua_ls", ...)` in `lua/user/options.lua` is not a reliable override, because `plugins/lsp.lua` configures `lua_ls` later |
| Enabled servers | `mason-lspconfig` enables only servers in the language table, not everything installed in Mason. To use another server, add it to `languages_local.lua` |
| Formatters | Installed automatically from the `tools` field by mason-tool-installer. `rustfmt` is the exception (comes with rustup) |
| Mason toolchains | Servers and tools install via npm, pip or go, so Node.js, Python 3 and Go must be present for the languages that need them |
| Tree-sitter branch | Pinned to `master` while Neovim is 0.12. Works today; plan a move to `main` and its new API |
| Format key | `<leader>cf`, deliberately not `<leader>f`, which is the Find prefix and would add a `timeoutlen` delay |
| Insert-mode `<C-h>` | Deliberately not mapped: many terminals send it for Backspace. Signature help is the built-in `<C-s>` |
| Which-key spec | Defined once, in `plugins/textobjects.lua`, from `config/leader_groups.lua:which_key_spec()` |
| Cheatsheet source | Started once, from `init.lua`. Do not add a second `setup()` call |
| User layer | `lua/user/*` is gitignored except the `*.example` files and `plugins/.gitkeep`. `config/lazy.lua` imports `user.plugins` only when that folder has a `.lua` file, because lazy.nvim prints an error for an imported folder with no specs |
| Lockfile | Personal copy by default (`util/lockfile.lua`). `vim.g.elite_lockfile_in_repo` must be set in `lua/user/options.lua`, which loads before lazy starts |
| Key tracking | Only `vim.keymap.set/del` calls made while `config.keymaps` / `user.keymaps` load are seen (not `nvim_set_keymap`, not later calls). Plugin keys set late are listed in `PLUGIN_KEYS` in `util/keyguard.lua` (currently toggleterm's `<C-\>`) |
| Prefix delays | The *shorter* of two overlapping keys waits `timeoutlen`; `keyguard` reports both directions |
| Terminal options | `plugins/terminal.lua` uses plain `opts`, so users rebind keys from `lua/user/plugins/`. Keep it that way |
| Terminal-mode keys | `jk`, `<Esc>` and `<C-h/j/k/l>` are set in a `FileType toggleterm` autocmd (buffer-local), not in `config/keymaps.lua`, so other terminals (lazygit, fzf, vim) get every key. `keyguard` only tracks `config.keymaps`, so it cannot see these |
| Keys-seen notice | `keyguard.setup()` writes `<state>/elite-keys-seen` only inside the `VimEnter` callback and only when a UI is attached, so headless runs (`smoke-test.sh`, the systemd watcher) do not use up the notice |
| Cmdline completion | nvim-cmp loads on `InsertEnter` and `CmdlineEnter`; its `cmp.setup.cmdline` calls live in its `config`, so dropping `CmdlineEnter` breaks `:` and `/` completion until the first Insert |
| Leader groups | `config/leader_groups.lua:all()` merges `vim.g.elite_leader_groups`; use `all()`, not `.groups`, in new code |
| Safety copies | `scripts/user-layer.sh backup` writes to `<XDG_STATE_HOME>/elite-backups`; `util/guide.lua:backup_dir()` and `elite/health.lua` assume that same path |
| Hand-cloned configs | No install record means `util/welcome.lua` shows a one-time notice (marker file `elite-manual-notice-shown`) |
| Extras | `util/extras.lua` is the registry (name, description, groups, keys, setup, health). `plugins = true` means `lua/extras/<name>.lua` exists and is imported by `config/lazy.lua` only when enabled (lazy prints an error for an import with no specs, so plugin-free extras have no file). Adding an extra: registry entry, optional spec file, a row in `docs/EXTRAS.md`, `COMPONENTS.md`, `KEYBINDINGS.md` |
| Extra keys | Defined in the registry's `keys(map)` and called from `init.lua` inside `keyguard.track_shipped`, so a user key on the same lhs is reported by `:EliteKeys`. Do not use lazy `keys = {}` in extra specs (invisible to keyguard). Groups of an extra are added by `leader_groups.all()` only while it is enabled |
| Extra: mason-tool-installer | `extras/dap.lua` extends the shipped `ensure_installed` with `opts = function(_, opts) ... end` (checked: the shipped list is kept and the adapters are appended) |
| Extra: sessions | `sessionoptions` omits `terminal`; nvim-tree is closed on `PersistenceSavePre`; `setup` is skipped when no UI is attached so headless runs never write a session |
| Extra: docker | `util/extras.lua:tui()` removes toggleterm's Terminal-mode `jk`/`<Esc>`/`<C-h/j/k/l>` buffer maps (set by the `FileType toggleterm` autocmd) in `on_open`, so the TUI receives them |
| Extra: dap | Adapters are looked up under `stdpath("data")/mason`. The `User EliteDapSetup` event lets users add configurations from `lua/user/options.lua` |
| Extra: rest | Own runner (`util/rest.lua`), because kulala.nvim now needs a downloaded binary with a license prompt and the `tree-sitter` CLI |
| Installer record | `scripts/install.sh` writes `<state>/elite-install-info`; `util/welcome.lua` and `scripts/uninstall.sh` read it. Keep the `key=value` format in sync if you change either side |

## 9. Mental model

Your configuration is source code, plugins are dependencies, lazy.nvim is the
package manager, and Neovim loads the result from `~/.config/nvim` (or
`~/.config/elite`).
