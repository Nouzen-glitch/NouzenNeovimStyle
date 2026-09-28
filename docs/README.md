# Elite Neovim IDE

A structured Neovim configuration that keeps Vim's modal editing and adds the
parts of VS Code that matter for programming: LSP IntelliSense, diagnostics,
completion, fuzzy finding, git hunks, formatting, and an integrated terminal.

Targets Neovim 0.11+ (currently running 0.12.x) on Linux (developed on Fedora).

## Docs

| File | Read it for |
| --- | --- |
| [KEYBINDINGS.md](KEYBINDINGS.md) | Every custom key, grouped by task, plus a learning order |
| [COMPONENTS.md](COMPONENTS.md) | What each plugin/tool is and which file configures it |
| [ENVIRONMENT_GUIDE.md](ENVIRONMENT_GUIDE.md) | Maintaining the config: workflow, git, cheatsheet automation, known issues |
| [cheatsheet.md](cheatsheet.md) | **Generated** from the running editor. Never edit by hand |

## Requirements

- Neovim 0.11+, `git`, a C compiler and `make` (Tree-sitter, LuaSnip, fzf-native)
- `ripgrep` (Telescope live grep), `curl`, `unzip` (Mason)
- A Nerd Font in your terminal (icons)

```bash
# Fedora
sudo dnf install neovim git ripgrep gcc gcc-c++ make curl unzip
# Arch
sudo pacman -S neovim git ripgrep base-devel curl unzip
```

## Install

**Recommended: symlink.** Keep one real copy in `~/dotfiles/nvim` and point
Neovim at it.

```bash
# back up anything existing first
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d-%H%M%S) 2>/dev/null
ln -s ~/dotfiles/nvim ~/.config/nvim
nvim        # lazy.nvim bootstraps and installs plugins
```

On another machine: `git clone <repo> ~/dotfiles/nvim`, then the same `ln -s`.

`scripts/install.sh` does the same thing for you: it backs up any existing
config and symlinks `~/.config/nvim` to this directory.

First launch checklist:

```vim
:Lazy          " plugins installed?
:Mason         " clangd, basedpyright, lua_ls, rust_analyzer, bashls
:checkhealth
```

## Layout

```text
~/dotfiles/nvim/
├── init.lua                  entry point (keep tiny)
├── lazy-lock.json            pinned plugin versions (commit this)
├── docs/                     README, KEYBINDINGS, COMPONENTS, ENVIRONMENT_GUIDE, generated cheatsheet
├── scripts/
│   ├── install.sh            backs up old config, symlinks this dir to ~/.config/nvim
│   └── generate-cheatsheet.sh  headless cheatsheet regeneration
├── systemd/                  user units that watch the config and regenerate the cheatsheet
└── lua/
    ├── config/
    │   ├── options.lua       editor behavior, leader = Space
    │   ├── keymaps.lua       custom keybindings
    │   ├── autocmds.lua      yank highlight, diagnostic display
    │   ├── lazy.lua          lazy.nvim bootstrap
    │   └── leader_groups.lua leader namespaces (feeds which-key and the cheatsheet)
    ├── plugins/              one spec file per concern
    │   ├── completion.lua  formatting.lua  git.lua  lsp.lua
    │   ├── telescope.lua  terminal.lua  textobjects.lua
    │   └── treesitter.lua  ui.lua
    └── util/
        └── cheatsheet.lua    cheatsheet generator (:Cheatsheet, :CheatsheetUpdate)
```

Where to change things:

| Want to change | Edit |
| --- | --- |
| Editor behavior | `config/options.lua` |
| Keybindings | `config/keymaps.lua` |
| Automatic behavior | `config/autocmds.lua` |
| Leader group labels | `config/leader_groups.lua` |
| Languages / LSP | `plugins/lsp.lua`, `treesitter.lua`, `formatting.lua` |
| Completion, snippets | `plugins/completion.lua` |
| Appearance, explorer | `plugins/ui.lua` |
| Terminal | `plugins/terminal.lua` |

## Day-one essentials

Leader is **Space**. `jk` exits Insert mode. Arrow keys are disabled on purpose.

| Key | Action |
| --- | --- |
| `<leader>ff` / `<leader>fg` | Find files / search project |
| `gd` `gr` `K` | Definition / references / hover docs |
| `<leader>rn` `<leader>ca` | Rename / code action |
| `<leader>cf` | Format (also runs on save) |
| `<leader>e` | File explorer |
| `<C-\>` | Toggle terminal |
| `<leader>?` | Show every keybinding (which-key) |
| `<leader>fC` | Open the generated cheatsheet |

Full list: [KEYBINDINGS.md](KEYBINDINGS.md).

## Health checks

```vim
:checkhealth            :checkhealth vim.lsp     :checkhealth mason
:checkhealth nvim-treesitter                     :ConformInfo
:Lazy                   :Mason                   :LspInfo
```

## Not included (yet)

DAP debugging, AI assistants, database/REST/Docker clients, terminal
multiplexing, dashboards.
