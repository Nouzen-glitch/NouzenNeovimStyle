# Elite Neovim IDE Configuration

This is a deliberately structured Neovim configuration aimed at replacing the
parts of VS Code that matter most for programming while preserving Vim's modal
editing model.

## What this gives you

- Vim modal editing
- `jk` to leave Insert mode
- Arrow keys disabled
- Space as `<leader>`
- LSP completion / IntelliSense
- Hover documentation
- Function signature help
- Go to definition / declaration / implementation
- Find references
- Symbol rename
- Code actions
- Diagnostics and error highlighting
- Inlay hints
- Tree-sitter syntax highlighting
- Snippets and Tab navigation
- Fuzzy file/project search
- File explorer
- Git gutter/hunks
- Formatting
- Diagnostics panel
- Which-key command discovery
- Useful text objects

## Important version note

This config targets modern Neovim (0.11+). `nvim-lspconfig` now uses
Neovim's `vim.lsp.config()` / `vim.lsp.enable()` architecture, and
`mason-lspconfig` can automatically enable installed servers.

The Tree-sitter config intentionally uses the `master` compatibility branch.
The current `nvim-treesitter` main branch has moved to a newer Neovim target.
If your Neovim is 0.12+ and you want the current Tree-sitter rewrite, update
`lua/plugins/treesitter.lua` to use the `main` branch and its newer API.

Official references:
- Neovim LSP: https://neovim.io/doc/user/lsp.html
- nvim-lspconfig: https://github.com/neovim/nvim-lspconfig
- lazy.nvim: https://github.com/folke/lazy.nvim
- nvim-cmp: https://github.com/hrsh7th/nvim-cmp
- nvim-treesitter: https://github.com/nvim-treesitter/nvim-treesitter
- mason.nvim: https://github.com/mason-org/mason.nvim
- mason-lspconfig: https://github.com/mason-org/mason-lspconfig.nvim

---

# 1. Install prerequisites

You need:

- Neovim 0.11+
- Git
- a C compiler
- ripgrep (`rg`) for Telescope live grep
- `make`
- `curl`
- `unzip`
- a Nerd Font is recommended for icons

For Arch:

```bash
sudo pacman -Syu
sudo pacman -S neovim git ripgrep base-devel curl unzip
```

For Fedora:

```bash
sudo dnf install neovim git ripgrep gcc gcc-c++ make curl unzip
```

Check:

```bash
nvim --version
git --version
rg --version
```

You want Neovim 0.11 or newer.

---

# 2. Back up your existing configuration

If you already have Neovim configured:

```bash
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)
```

Also, if you want a completely clean plugin/data state:

```bash
mv ~/.local/share/nvim ~/.local/share/nvim.backup.$(date +%Y%m%d-%H%M%S)
mv ~/.local/state/nvim ~/.local/state/nvim.backup.$(date +%Y%m%d-%H%M%S)
mv ~/.cache/nvim ~/.cache/nvim.backup.$(date +%Y%m%d-%H%M%S)
```

Do NOT delete these until you are certain the new configuration works.

---

# 3. Install this configuration

Copy the contents of this directory to:

```text
~/.config/nvim/
```

For example, if you downloaded this repository/archive to
`~/nvim-elite-config`:

```bash
mkdir -p ~/.config
cp -r ~/nvim-elite-config ~/.config/nvim
```

Then:

```bash
nvim
```

lazy.nvim will bootstrap itself and install the plugins.

Inside Neovim:

```vim
:Lazy
```

should show the installed plugins.

---

# 4. Install language servers

This configuration uses Mason.

Open:

```bash
nvim
```

Then:

```vim
:Mason
```

You should see:

- clangd
- basedpyright
- lua-language-server
- rust-analyzer
- bash-language-server

The configuration asks mason-lspconfig to ensure those servers are installed.

You can manually install anything with:

```vim
:MasonInstall clangd
:MasonInstall basedpyright
:MasonInstall lua-language-server
:MasonInstall rust-analyzer
:MasonInstall bash-language-server
```

---

# 5. Verify LSP

Open a C file:

```bash
nvim main.c
```

Then:

```vim
:LspInfo
```

or:

```vim
:checkhealth vim.lsp
```

You should see `clangd` attached.

Test:

```text
K       hover documentation
gd      definition
gD      declaration
gi      implementation
gr      references
```

---

# 6. IntelliSense / completion

Inside a source file:

```text
<C-Space>     manually trigger completion
<C-j>         next completion item
<C-k>         previous completion item
<CR>          accept selected item
<C-e>         close completion
<C-d>         scroll documentation down
<C-f>         scroll documentation up
<Tab>         next completion / expand snippet
<S-Tab>       previous completion / previous snippet position
```

The completion window gets its information from LSP plus snippets,
buffer words, and filesystem paths.

---

# 7. Function arguments / signature help

While typing a function call:

```text
<C-h>
```

opens LSP signature help.

Hovering over a symbol and pressing:

```text
K
```

opens its documentation/type information.

This is the closest part of the setup to VS Code's "I forgot what arguments
this function takes" experience.

---

# 8. Diagnostics

Errors and warnings appear under the offending code.

Use:

```text
[d          previous diagnostic
]d          next diagnostic
<leader>de  diagnostic details
<leader>xx  full diagnostics panel
<leader>xX  diagnostics for current buffer
```

The diagnostics panel is provided by Trouble.

---

# 9. Navigation

The most important commands to learn:

```text
gd          go to definition
gD          go to declaration
gi          go to implementation
gr          references
K           documentation
```

For project navigation:

```text
<leader>ff  find files
<leader>fg  search entire project
<leader>fb  buffers
<leader>fr  recent files
<leader>fh  Neovim help
```

---

# 10. File explorer

```text
<leader>e
```

opens/toggles nvim-tree.

Useful commands inside the tree are shown by:

```text
g?
```

---

# 11. Git

Gitsigns shows modifications in the gutter.

```text
[h          previous hunk
]h          next hunk
<leader>hs  stage hunk
<leader>hr  reset hunk
<leader>hp  preview hunk
```

---

# 12. Formatting

```text
<leader>f
```

formats the current file/selection.

Formatting is also configured to happen on save for supported languages.

Configured formatters include:

- C/C++ -> clang-format
- Python -> ruff
- Lua -> stylua
- Rust -> rustfmt
- JS/TS/JSON/YAML/Markdown -> prettier
- Bash -> shfmt

Mason can be used to install language servers and tools. If a formatter is
not available, Conform falls back to LSP formatting when possible.

---

# 13. Inlay hints

```text
<leader>ih
```

toggles LSP inlay hints.

These can show inferred types, parameter names, and other information
depending on the language server.

---

# 14. Windows

```text
<C-h>  left
<C-j>  down
<C-k>  up
<C-l>  right

<leader>wv  vertical split
<leader>ws  horizontal split
<leader>wd  close window
```
### Integrated Terminal

`<C-\>` toggles a persistent VS Code-style terminal window at the bottom.

Inside the active terminal window:
- `<Esc>`       Exit terminal input mode (switch to Normal mode to scroll or search)
- `i` or `a`    Re-enter terminal input mode to type commands
- `<C-h>`       Navigate out to the left window split
- `<C-j>`       Navigate out to the bottom window split
- `<C-k>`       Navigate out to the top window split
- `<C-l>`       Navigate out to the right window split

---

# 15. Buffers

```text
Shift-h       previous buffer
Shift-l       next buffer
<leader>bd    delete buffer
```

---

# 16. The Vim movement system

Arrow keys are deliberately disabled.

Learn:

```text
h j k l       basic movement
w             next word
b             previous word
e             end of word
0             beginning of line
^             first non-whitespace character
$             end of line
gg            top of file
G             bottom of file
Ctrl-d        half page down
Ctrl-u        half page up
f<char>       find character
t<char>       until character
%             matching bracket
```

Then learn combinations:

```text
dw
d$
ci"
ci(
ci{
yiw
da{
```

The point is not merely to move quickly. The point is to express edits as
small commands that compose with one another.

---

# 17. Leader-key philosophy

Leader is Space:

```text
<leader> = Space
```

Main namespaces:

```text
f   Find / format
g   Git
x   Diagnostics
c   Code / LSP-related actions
d   Diagnostic details
w   Windows
b   Buffers
e   Explorer
h   Git hunks
i   Inlay hints
r   Rename
```

Press:

```text
<leader>
```

and Which-Key will show available mappings.

---

# 18. Useful health checks

If something is broken, do these first:

```vim
:checkhealth
:checkhealth vim.lsp
:checkhealth mason
:Lazy
:Mason
:LspInfo
```

For Tree-sitter:

```vim
:checkhealth nvim-treesitter
```

For a specific LSP server, also check that its executable exists:

```bash
which clangd
which rust-analyzer
```

Mason-managed servers normally live under Neovim's data directory and Mason
adds its bin directory to Neovim's PATH.

---

# 19. Configuration layout

The configuration intentionally separates concerns:

```text
~/.config/nvim/
├── init.lua
├── README.md
└── lua/
    ├── config/
    │   ├── options.lua
    │   ├── keymaps.lua
    │   ├── autocmds.lua
    │   └── lazy.lua
    │
    └── plugins/
        ├── completion.lua
        ├── formatting.lua
        ├── git.lua
        ├── lsp.lua
        ├── telescope.lua
        ├── textobjects.lua
        ├── treesitter.lua
        └── ui.lua
        └── terminal.lua
        
```

```

This is intentional.

When you want to change something:

```text
editor behavior       -> config/options.lua
keybindings            -> config/keymaps.lua
automatic behavior     -> config/autocmds.lua
LSP                    -> plugins/lsp.lua
completion             -> plugins/completion.lua
syntax                 -> plugins/treesitter.lua
formatting              -> plugins/formatting.lua
Git                    -> plugins/git.lua
search                 -> plugins/telescope.lua
UI                      -> plugins/ui.lua
```

---

# 20. Recommended learning order

Do NOT try to memorize everything on day one.

### Stage 1

Learn:

```text
i
a
o
Esc / jk
h j k l
w b e
0 ^
$
dd
yy
p
u
Ctrl-r
```

### Stage 2

Learn operators + text objects:

```text
d
c
y

iw
aw
i"
a"
i(
a(
i{
a{
```

### Stage 3

Learn project navigation:

```text
Space ff
Space fg
gd
gr
K
```

### Stage 4

Learn completion:

```text
Tab
Shift-Tab
Ctrl-Space
Ctrl-j
Ctrl-k
Ctrl-h
```

### Stage 5

Learn LSP refactoring:

```text
Space rn
Space ca
gi
gr
```

### Stage 6

Git + diagnostics + advanced plugins.

The goal is to make the basic operations automatic before adding more
complexity.

---

# 21. Updating the configuration

Plugins are managed by lazy.nvim.

Inside Neovim:

```vim
:Lazy
```

Then press:

```text
U
```

to update plugins.

The resulting `lazy-lock.json` records exact plugin revisions. Commit that
file if you put this configuration in Git.

A good setup is therefore:

```text
your dotfiles repository
        |
        +-- ~/.config/nvim
        |
        +-- lazy-lock.json
        |
        +-- README.md
```

That makes the entire editor reproducible on another Linux machine.

---

# 22. Backing up / moving the setup

Once you like the configuration:

```bash
cd ~/.config
git init nvim
cd nvim
git add .
git commit -m "Initial Neovim configuration"
```

Then on another machine:

```bash
git clone <your-repository> ~/.config/nvim
```

Start:

```bash
nvim
```

and lazy.nvim will bootstrap and install the plugins.

---

# 23. What this does NOT include yet

- Debug Adapter Protocol / DAP
- AI coding assistants
- database clients
- Docker/Kubernetes integrations
- REST clients
- terminal multiplexing
- elaborate dashboards
- elaborate animations
- dozens of language servers
- dozens of color/UI plugins
