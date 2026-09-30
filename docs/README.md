# Elite Neovim IDE

A structured Neovim configuration that keeps Vim's modal editing and adds the
parts of VS Code that matter for programming: LSP IntelliSense, diagnostics,
completion, fuzzy finding, git hunks, formatting, and an integrated terminal.

Targets Neovim 0.11+ (currently running 0.12.x) on Linux (developed on Fedora).

## Docs

| File | Read it for |
| --- | --- |
| [GETTING_STARTED.md](GETTING_STARTED.md) | Start here: your first 15 minutes, what to do and what to avoid |
| [INSTALL.md](INSTALL.md) | Installing (alongside or replace), every script and flag, updating, undoing, troubleshooting |
| [MIGRATING.md](MIGRATING.md) | Customizing without editing shipped files; bringing your own config and plugins |
| [KEYBINDINGS.md](KEYBINDINGS.md) | Every custom key, grouped by task, plus a learning order |
| [ADDING_LANGUAGES.md](ADDING_LANGUAGES.md) | Adding a language: one line, nothing installed unless listed |
| [COMPONENTS.md](COMPONENTS.md) | What each plugin/tool is and which file configures it |
| [ENVIRONMENT_GUIDE.md](ENVIRONMENT_GUIDE.md) | Maintaining the config: workflow, git, cheatsheet automation, known issues |
| [../CHANGELOG.md](../CHANGELOG.md) | What changed, newest first (`scripts/update.sh` prints new entries) |

The live cheatsheet is **generated** from the running editor (`<leader>fC` or
`:Cheatsheet`). It is stored in Neovim's state folder, not in this repo.

## Requirements

- Neovim 0.11+, `git`, a C compiler and `make` (Tree-sitter, LuaSnip, fzf-native)
- `ripgrep` (Telescope live grep), `curl`, `unzip` (Mason)
- A Nerd Font in your terminal (icons)
- Node.js + npm, Python 3, and optionally Go: Mason uses them to install language servers and formatters

```bash
# Fedora
sudo dnf install neovim git ripgrep gcc gcc-c++ make curl unzip nodejs npm python3 golang
# Arch
sudo pacman -S neovim git ripgrep base-devel curl unzip
```

## Install

```bash
git clone <repo> ~/dotfiles/nvim
~/dotfiles/nvim/scripts/install.sh
```

Always install with `scripts/install.sh` rather than cloning straight into
`~/.config/nvim`: the script gives you undo, a backup of your old config, a
safety copy of your personal files and the `nvim-elite` launcher. Your personal
files (`lua/user/`) live inside the cloned folder and are not in git, so keep
that folder, and run `scripts/user-layer.sh export` (or `:EliteBackup`) before
deleting or re-cloning it.

The installer never deletes anything. If you already have a Neovim config it
asks how to proceed:

| Choice | Result |
| --- | --- |
| **Alongside** (default, safest) | Run this config with `nvim-elite`. Your current `nvim` and its plugins are not touched. |
| **Replace** | This becomes `nvim`. Your old config is moved to `~/.config/nvim.backup.<timestamp>`. |

| Script | Purpose |
| --- | --- |
| `scripts/install.sh` | Install. Flags: `--alongside`, `--replace`, `--appname NAME`, `--clean-data`, `--dry-run`, `--yes` |
| `scripts/uninstall.sh` | Remove the link and launcher, restore your backup. Flags: `--appname`, `--dry-run`, `--yes` |
| `scripts/update.sh` | Pull the latest config and show what changed. Flag: `--check` |
| `scripts/user-layer.sh` | `list`, `export`, `import`, `backup`, `backups` for your personal files (not in git) |

What every flag does, worked scenarios (first install, trying it out, switching,
updating, a second machine, undoing) and troubleshooting are in
[INSTALL.md](INSTALL.md). Add `--dry-run` to see what would happen first.

First launch checklist:

```vim
:Lazy              " plugins installed?
:Mason             " servers and tools from config/languages.lua
:checkhealth elite " tools, versions, install state
:EliteInfo         " how this config was installed, where any backup is
:EliteHelp         " one-screen guide: what you can do and should do
:EliteTutor        " short practice tutorial
```

## Layout

```text
~/dotfiles/nvim/
├── init.lua                  entry point (keep tiny)
├── lazy-lock.json            plugin versions the maintainer tested (seeds each user's personal copy)
├── CHANGELOG.md              what changed, newest first
├── .gitignore                keeps your personal layer out of git
├── docs/                     README, INSTALL, MIGRATING, KEYBINDINGS, ADDING_LANGUAGES, COMPONENTS, ENVIRONMENT_GUIDE
├── scripts/
│   ├── install.sh            alongside or replace install, with backup and dry-run
│   ├── uninstall.sh          removes the link, restores your backup
│   ├── update.sh             pulls updates, shows what changed
│   ├── user-layer.sh         export/import your personal files
│   ├── smoke-test.sh         headless check that the modules load (for maintainers)
│   └── generate-cheatsheet.sh  headless cheatsheet regeneration
├── systemd/                  user units that watch the config and regenerate the cheatsheet
└── lua/
    ├── config/
    │   ├── options.lua       editor behavior, leader = Space
    │   ├── keymaps.lua       custom keybindings
    │   ├── autocmds.lua      yank highlight, cursor restore, diagnostic display
    │   ├── languages.lua     default languages: LSP, parser, formatter, tools
    │   ├── languages_local.lua  YOUR additions (optional, you create it, gitignored)
    │   ├── lazy.lua          lazy.nvim bootstrap
    │   └── leader_groups.lua leader namespaces (feeds which-key and the cheatsheet)
    ├── plugins/              one spec file per concern
    │   ├── completion.lua  formatting.lua  git.lua  lsp.lua
    │   ├── telescope.lua  terminal.lua  textobjects.lua
    │   └── treesitter.lua  ui.lua
    ├── user/                 YOUR options, keymaps and plugins (gitignored; *.example files show how)
    ├── elite/
    │   └── health.lua        :checkhealth elite
    └── util/
        ├── cheatsheet.lua    cheatsheet generator (:Cheatsheet, :CheatsheetUpdate)
        ├── languages.lua     derives plugin lists from config/languages.lua
        ├── lockfile.lua      personal plugin lockfile (:EliteLockReset)
        ├── user.lua          loads your lua/user/ files, reports errors in them
        ├── keyguard.lua      reports shipped keys your keymaps replace (:EliteKeys)
        ├── guide.lua         :EliteHelp, :EliteTutor, :EliteEdit, :EliteBackup
        └── welcome.lua       first-run install window, :EliteInfo
```

Where to change things:

| Want to change | Edit |
| --- | --- |
| Anything just for you | `lua/user/` (options, keymaps, plugins), see [MIGRATING.md](MIGRATING.md) |
| Updating this config | `scripts/update.sh`, see [INSTALL.md](INSTALL.md) |
| Editor behavior (project default) | `config/options.lua` |
| Keybindings (project default) | `config/keymaps.lua` |
| Automatic behavior | `config/autocmds.lua` |
| Leader group labels | `config/leader_groups.lua` |
| Languages (LSP, syntax, formatting) | `config/languages_local.lua` for yours, `config/languages.lua` for defaults (see ADDING_LANGUAGES.md) |
| Completion, snippets | `plugins/completion.lua` |
| Appearance, explorer | `plugins/ui.lua` |
| Terminal | `plugins/terminal.lua` |

## Day-one essentials

Leader is **Space**. `jk` exits Insert mode. Arrow keys are disabled on purpose
(`vim.g.elite_disable_arrows = false` in `lua/user/options.lua` turns that off).

| Key | Action |
| --- | --- |
| `<leader>ff` / `<leader>fg` | Find files / search project |
| `gd` `gr` `K` | Definition / references / hover docs |
| `<leader>rn` `<leader>ca` | Rename / code action |
| `<leader>cf` | Format (also runs on save) |
| `<C-s>` | Save |
| `<leader>e` | File explorer |
| `<C-\>` | Toggle terminal |
| `<leader>?` | Show every keybinding (which-key) |
| `<leader>fC` | Open the generated cheatsheet |
| `<leader>fi` / `:EliteHelp` | One-screen guide: what you can do and should do |

Full list: [KEYBINDINGS.md](KEYBINDINGS.md).

## Health checks

```vim
:checkhealth elite      :checkhealth vim.lsp     :checkhealth mason
:checkhealth nvim-treesitter                     :ConformInfo
:Lazy                   :Mason
```

## Not included (yet)

DAP debugging, AI assistants, database/REST/Docker clients, persistent
terminal sessions (tmux/zellij-style detach and reattach), dashboards,
session restore, a Windows installer.
Multiple numbered terminals are supported via toggleterm (`2<C-\>`, `:TermSelect`).
Anything from this list can be added through `lua/user/plugins/`.
