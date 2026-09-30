# Customizing and Migrating

How to make this config yours without editing its files, and how to bring an
existing Neovim setup along. Installing, updating and undoing are in
[INSTALL.md](INSTALL.md).

## 1. Your personal layer

Everything below is yours and is **gitignored**, so `scripts/update.sh` and
`git pull` never conflict with it. Copy the `.example` files next to them to
start.

| File | Loaded | Use it for |
| --- | --- | --- |
| `lua/user/options.lua` | Right after `config/options.lua` | Your options; the `vim.g.elite_*` switches in section 3. Your values win. |
| `lua/user/keymaps.lua` | Right after `config/keymaps.lua` | Your keymaps. If a key is already mapped, yours replaces it. Give each mapping a `desc` so it shows in `<leader>?`. |
| `lua/user/plugins/*.lua` | After the shipped plugins | Extra lazy.nvim plugin specs, and changes to shipped ones (section 4). |
| `lua/config/languages_local.lua` | With the language table | Languages: server, parser, formatter ([ADDING_LANGUAGES.md](ADDING_LANGUAGES.md)). |

A missing file is fine. A mistake **inside** one of your files is shown as an
error message naming the file and line, and the rest of the config still
loads. `lua/user/plugins/` is only used once it contains a `.lua` file.

Check what you have with `scripts/user-layer.sh list` or `:checkhealth elite`.

## 2. Bringing your old config over

1. **Find your old config.** After a *replace* install it is in the backup
   folder (`:EliteInfo` shows the path). After an *alongside* install it is
   simply your normal `~/.config/nvim`.
2. **Options:** copy the settings you care about into `lua/user/options.lua`.
3. **Keymaps:** copy them into `lua/user/keymaps.lua`.
4. **Plugins:** if your old config used lazy.nvim, its spec files can go into
   `lua/user/plugins/` as they are. For packer or vim-plug, convert each
   plugin to a spec (section 4 shows the shape).
5. **Restart Neovim.** New plugins install on start. Then run
   `:checkhealth elite`.

Things that can surprise you:

| Topic | What happens |
| --- | --- |
| Same key, two owners | Yours wins (it loads later). Use `<leader>fk` to see what a key does first. |
| Same plugin in both places | lazy.nvim merges the two specs; `opts` tables are merged deeply. |
| Arrow keys | Disabled by default. See `vim.g.elite_disable_arrows` below. |
| Language servers | Only servers in the language table are enabled. One that is merely installed in Mason stays off until you add it to `languages_local.lua`. |
| Old plugin data | Plugins left over from another setup can load in replace mode. Use `--clean-data` or install alongside ([INSTALL.md](INSTALL.md)). |

## 3. Switches you can set

Put these in `lua/user/options.lua`. They must be set there (not later) because
they are read while the config loads.

| Setting | Default | Effect |
| --- | --- | --- |
| `vim.g.elite_disable_arrows = false` | arrows disabled | Re-enable the arrow keys in normal, insert and visual mode. |
| `vim.g.elite_lockfile_in_repo = true` | personal lockfile | Track plugin versions in the repo's `lazy-lock.json` instead of a personal copy. For maintainers who commit it. See [INSTALL.md](INSTALL.md) section 8. |

Everything else is an ordinary Neovim option, for example
`vim.opt.shiftwidth = 2`.

## 4. Changing shipped plugins without editing them

lazy.nvim merges specs that name the same plugin, so a file in
`lua/user/plugins/` can add, tweak or disable:

```lua
-- lua/user/plugins/mine.lua
return {
    -- add a plugin
    { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },

    -- change a shipped plugin's options
    { "nvim-telescope/telescope.nvim", opts = { defaults = { layout_strategy = "vertical" } } },

    -- turn a shipped plugin off
    { "folke/trouble.nvim", enabled = false },
}
```

`lua/user/plugins/example.lua.example` has the same snippets to copy from.

## 5. Keeping your layer safe and portable

Your personal files are not in the project's git history. To back them up or
move them to another machine:

```bash
scripts/user-layer.sh export ~/elite-user.tar.gz      # on the old machine
scripts/user-layer.sh import ~/elite-user.tar.gz      # on the new one
```

Details and safety checks are in [INSTALL.md](INSTALL.md), section 6. If you
prefer git, you can also fork the repo and remove the personal-file lines from
`.gitignore` to track them there.

## 6. Commands added by this config

| Command | Use |
| --- | --- |
| `:checkhealth elite` | Versions, required tools, install state, your personal files |
| `:EliteInfo` | How this config was installed and where any backup is |
| `:EliteLockReset` | Adopt the plugin versions shipped with the config |
| `:Cheatsheet` / `:CheatsheetUpdate` | Open / regenerate the live cheatsheet |
