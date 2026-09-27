
# Neovim Environment Guide

## 1. Source vs active configuration

Keep your master configuration here:

```text
~/dotfiles/nvim/
├── init.lua
├── README.md
├── COMPONENTS.md
├── ENVIRONMENT_GUIDE.md
└── lua/
    ├── config/
    └── plugins/
```

Neovim actually loads:

```text
~/.config/nvim/
```

The cleanest setup is for `~/.config/nvim` to be a symlink to
`~/dotfiles/nvim`. Then there is only one real copy to edit.

```text
~/dotfiles/nvim  --->  ~/.config/nvim  --->  Neovim
     master             active path
```

If you edit a file in `~/dotfiles/nvim`, Neovim sees the change immediately
because `~/.config/nvim` points to it.

## 2. What each part does

### `init.lua`
The entry point. It loads your options, keymaps, autocommands, and plugin
manager. Keep it small.

### `lua/config/options.lua`
General Neovim behavior: indentation, search, clipboard, scrolling, splits,
line numbers, etc.

### `lua/config/keymaps.lua`
Your keyboard shortcuts such as `Space ff`, `gd`, `K`, `Space rn`, and
`Space f`.

### `lua/config/autocmds.lua`
Automatic behavior triggered by events, such as yank highlighting and
diagnostic configuration.

### `lua/config/lazy.lua`
Bootstraps/configures `lazy.nvim`. Normally you rarely need to edit this.

### `lua/plugins/`
Plugin specifications. Each file groups related plugins.

For this setup:

```text
completion.lua   autocomplete/snippets
formatting.lua   formatters
git.lua          Git integration
lsp.lua          language servers
telescope.lua    searching/finding
textobjects.lua  text objects/which-key
treesitter.lua   syntax parsing
ui.lua           theme/statusline/file explorer
```

## 3. Adding a plugin

Create a file under `lua/plugins/`, for example:

```bash
nvim ~/.config/nvim/lua/plugins/example.lua
```

Add the plugin specification. `lazy.nvim` will install it when Neovim starts.

Do not manually edit installed plugin source code.

## 4. Removing a plugin

Remove its specification from `lua/plugins/`. Then use:

```vim
:Lazy clean
```

to remove plugins that are no longer referenced.

## 5. Changing a plugin

Edit its specification under `lua/plugins/`. For example:

```text
lsp.lua          → LSP behavior
completion.lua   → autocomplete
treesitter.lua   → syntax
formatting.lua   → formatters
ui.lua           → appearance/explorer
```

Restart Neovim after changes while you are learning. Some plugins can reload
without restarting, but restarting is the simplest reliable workflow.

## 6. Adding a programming language

Usually check three places:

```text
lua/plugins/lsp.lua
lua/plugins/treesitter.lua
lua/plugins/formatting.lua
```

A language commonly needs:

```text
LSP          → intelligence, definitions, diagnostics, completion
Tree-sitter  → syntax parsing/highlighting
Formatter    → formatting
```

For example, C/C++ uses `clangd`, Tree-sitter C/C++, and `clang-format`.

## 7. Useful commands

```vim
:Lazy
```
Plugin manager.

```vim
:Lazy update
```
Update plugins.

```vim
:Lazy clean
```
Remove unused plugins.

```vim
:Mason
```
Manage language servers and other external tools.

```vim
:LspInfo
```
Show which language server is attached to the current buffer.

```vim
:checkhealth
```
Diagnose Neovim/dependency problems.

```vim
:TSUpdate
```
Update Tree-sitter parsers.

```vim
:ConformInfo
```
Show formatting information for the current buffer.

## 8. Recommended change workflow

```text
1. Decide what you want to change.
2. Identify the appropriate file.
3. Edit it.
4. Restart Neovim.
5. Test it.
6. If it works, commit it to Git.
7. If it breaks, revert the change.
```

Examples:

```text
New shortcut       → config/keymaps.lua
General behavior   → config/options.lua
Automatic action   → config/autocmds.lua
New plugin         → plugins/*.lua
LSP/language       → plugins/lsp.lua
Syntax             → plugins/treesitter.lua
Formatting         → plugins/formatting.lua
Appearance         → plugins/ui.lua
```

## 9. Git

Treat this configuration like a software project:

```bash
cd ~/dotfiles/nvim
git init
git add .
git commit -m "Initial Neovim configuration"
```

After a successful change:

```bash
git add .
git commit -m "Describe the change"
```

This lets you recover from bad configuration changes and eventually
synchronize the same setup to another machine.

## 10. Do not manually edit plugin installations

Your configuration is yours:

```text
~/dotfiles/nvim/
```

Plugin installations/cache/state are managed elsewhere by Neovim and
`lazy.nvim`.

Do not modify installed plugin source directly. Updates can overwrite those
changes.

## 11. The mental model

```text
~/dotfiles/nvim/
       │
       │ symlink
       ▼
~/.config/nvim/
       │
       ▼
   init.lua
       │
       ├── config/options.lua
       ├── config/keymaps.lua
       ├── config/autocmds.lua
       └── config/lazy.lua
                │
                ▼
             lazy.nvim
                │
                ▼
          lua/plugins/*.lua
                │
       ┌────────┼────────┐
       ▼        ▼        ▼
      LSP   completion  Tree-sitter
       │        │        │
       └────────┼────────┘
                ▼
          Neovim IDE
```

**Core principle:** your configuration is source code; plugins are
dependencies; `lazy.nvim` manages those dependencies; Neovim loads the
configuration automatically.
