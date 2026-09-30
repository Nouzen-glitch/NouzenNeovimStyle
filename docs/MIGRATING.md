# Migrating and Customizing

How to install without losing your current setup, bring your own config and
plugins along, and go back if you change your mind.

## 1. Two ways to install

| Mode | Command | What happens |
| --- | --- | --- |
| **Alongside** (safest) | `scripts/install.sh --alongside` | Installed as its own app. Start it with `nvim-elite`. Your normal `nvim` and everything it stores are not touched. |
| **Replace** | `scripts/install.sh --replace` | This becomes your `nvim`. An existing `~/.config/nvim` is **moved** to `~/.config/nvim.backup.<timestamp>`, never deleted. |

Run `scripts/install.sh` with no options to be asked. If you already have a
config and the script cannot ask (for example in a pipeline), it installs
alongside. Add `--dry-run` to see exactly what would happen first.

Alongside mode works through Neovim's `NVIM_APPNAME`: config, plugins, state
and cache move from `nvim` to `elite`:

| What | Replace | Alongside |
| --- | --- | --- |
| Config | `~/.config/nvim` | `~/.config/elite` |
| Plugins and data | `~/.local/share/nvim` | `~/.local/share/elite` |
| State | `~/.local/state/nvim` | `~/.local/state/elite` |
| Cache | `~/.cache/nvim` | `~/.cache/elite` |

`nvim-elite` is a two-line launcher in `~/.local/bin` (make sure that folder is
on your `PATH`).

### Reinstalling Neovim itself

Updating or reinstalling the Neovim package does not touch any of the folders
above. Your config, and the symlink to it, stay exactly as they were.

### Leftover data from an old setup

The backup only covers the config folder. Plugins from an older setup (for
example packer) live in `~/.local/share/nvim` and can still load under a
replaced config. Either install alongside, or use
`scripts/install.sh --replace --clean-data`, which moves the old data, state
and cache folders aside to `*.backup.<timestamp>` too.

## 2. How you know what happened

- The installer ends with a summary box: what was linked, where any backup is,
  how to start, and how to undo.
- The first time Neovim starts it shows the same information once.
- `:EliteInfo` shows it again at any time.
- `:checkhealth elite` checks versions, required tools and the state of your
  personal layer.

## 3. Going back

```bash
scripts/uninstall.sh            # removes the link and launcher, restores your backup
scripts/uninstall.sh --dry-run  # preview
```

Plugin data folders are left in place; the script lists them so you can delete
them for a clean slate.

## 4. Your personal layer: `lua/user/`

Everything in `lua/user/` is yours and is gitignored, so `git pull` never
conflicts with it. Copy the `.example` files and edit:

| File | Purpose |
| --- | --- |
| `lua/user/options.lua` | Loaded right after `config/options.lua`. Your options win. |
| `lua/user/keymaps.lua` | Loaded right after `config/keymaps.lua`. Same key = yours wins. |
| `lua/user/plugins/*.lua` | Extra lazy.nvim specs, loaded after the shipped plugins. |
| `lua/config/languages_local.lua` | Languages (see [ADDING_LANGUAGES.md](ADDING_LANGUAGES.md)). |

Because lazy.nvim merges specs that name the same plugin (and deep-merges
`opts`), you can change shipped plugins without editing their files:

```lua
-- lua/user/plugins/mine.lua
return {
    { "ThePrimeagen/harpoon", branch = "harpoon2" },                          -- add
    { "nvim-telescope/telescope.nvim", opts = { defaults = { layout_strategy = "vertical" } } }, -- tweak
    { "folke/trouble.nvim", enabled = false },                                -- remove
}
```

### Bringing your old config over

1. Find the backup path (`:EliteInfo`, or the installer summary).
2. **Options:** copy the settings you care about into `lua/user/options.lua`.
3. **Keymaps:** copy them into `lua/user/keymaps.lua`. Give each one a `desc`
   so it shows up in `<leader>?` and the cheatsheet.
4. **Plugins:** if your old config used lazy.nvim, its spec files can be copied
   into `lua/user/plugins/` as they are. For packer or vim-plug, convert each
   plugin to a spec like the ones above.
5. Restart Neovim, then run `:Lazy` and `:checkhealth elite`.

### Things to know when merging

- **Same key, two owners.** If your keymap uses a key already used here, yours
  wins (it loads later). Use `<leader>fk` to check what a key does first.
- **Arrow keys.** They are disabled by default. Put
  `vim.g.elite_disable_arrows = false` in `lua/user/options.lua` to turn that
  off.
- **Language servers.** Only servers in the language table are enabled. A
  server that is merely installed in Mason stays off until you add it to
  `languages_local.lua`.
- **Lockfile.** Plugins you add change `lazy-lock.json`, which is tracked. If
  you do not want that in your commits, `git update-index --skip-worktree
  lazy-lock.json`, or keep your own copy.
- **A mistake in a `user/` file** is reported as an error message on startup;
  it does not stop the rest of the config from loading.
