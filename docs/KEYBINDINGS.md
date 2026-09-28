# Keybindings

Custom bindings from `lua/config/keymaps.lua` and plugin configs. Leader is
**Space**. For the live, complete list (including built-ins and plugin
defaults) use `<leader>?`, `<leader>fk`, or [cheatsheet.md](cheatsheet.md).

## Fundamentals

| Key | Mode | Action |
| --- | --- | --- |
| `jk` | i, t | Leave Insert / Terminal mode |
| Arrow keys | n, i, v | Disabled (`<Nop>`) |
| `j` / `k` | n | Move by display line (wrapped lines) |
| `n` / `N` | n | Next / previous search result, centered |
| `<` / `>` | v | Indent and keep selection |

## Windows and buffers

| Key | Action |
| --- | --- |
| `<C-h/j/k/l>` | Focus left / down / up / right window |
| `<leader>wv` / `<leader>ws` | Vertical / horizontal split |
| `<leader>wd` | Close window |
| `<leader>ww` | Cycle windows |
| `H` / `L` | Previous / next buffer |
| `<leader>bd` | Delete buffer |

## LSP

| Key | Action |
| --- | --- |
| `K` | Hover documentation |
| `gd` `gD` `gi` `gr` | Definition / declaration / implementation / references |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (n, v) |
| `<leader>ih` | Toggle inlay hints |
| `<C-h>` (insert) | Signature help |

Neovim 0.11+ also provides defaults: `grn` rename, `gra` code action, `grr`
references, `gri` implementation, `grt` type definition, `gO` symbols,
`<C-s>` (insert/select) signature help.

## Diagnostics

| Key | Action |
| --- | --- |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>de` | Diagnostic float |
| `<leader>dq` | Send diagnostics to quickfix |
| `<leader>xx` | Trouble: all diagnostics |
| `<leader>xX` | Trouble: current buffer |

## Find (Telescope)

| Key | Action |
| --- | --- |
| `<leader>ff` | Files |
| `<leader>fg` | Live grep (needs `rg`) |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>fC` | Open generated cheatsheet |
| `<leader>?` | which-key: all keybindings |

## Explorer, formatting, git

| Key | Action |
| --- | --- |
| `<leader>e` | Toggle nvim-tree (`g?` inside for its help) |
| `<leader>cf` | Format file / selection (n, v); also runs on save |
| `]h` / `[h` | Next / previous git hunk |
| `<leader>hs` `hr` `hp` | Stage / reset / preview hunk |

## Completion (insert mode, nvim-cmp)

| Key | Action |
| --- | --- |
| `<C-Space>` | Trigger completion |
| `<C-j>` / `<C-k>` | Next / previous item |
| `<Tab>` / `<S-Tab>` | Next / previous item, or jump in a snippet |
| `<CR>` | Accept selected item (nothing preselected) |
| `<C-e>` | Close menu |
| `<C-d>` / `<C-f>` | Scroll docs up / down |

Command-line (`:` and `/`) also has completion.

## Terminal (toggleterm)

| Key | Action |
| --- | --- |
| `<C-\>` | Toggle bottom terminal (works from every mode) |
| `<Esc>` or `jk` | Terminal mode to Normal mode (scroll, search) |
| `i` / `a` | Back to typing |
| `<C-h/j/k/l>` | Leave terminal to that window |

## Text objects and editing

`mini.ai` extends `a`/`i` objects (arguments, function calls, quotes,
brackets). Built-ins used constantly: `ciw`, `ci"`, `ci(`, `da{`, `yiw`.
`gcc` toggles a comment, `gc` + motion/selection comments a range.

## Leader namespaces

`f` Find, `w` Windows, `x` Diagnostics list, `h` Git hunks,
`b` Buffers, `e` Explorer, `c` Code (actions, format), `d` Diagnostic details,
`i` Inlay hints, `r` Rename. Press `<leader>` and wait for which-key.

## Learning order

1. Insert/leave (`i a o`, `jk`), `hjkl`, `w b e`, `0 ^ $`, `dd yy p u <C-r>`
2. Operators plus text objects: `d c y` with `iw aw i" i( i{`
3. Navigation: `<leader>ff`, `<leader>fg`, `gd`, `gr`, `K`
4. Completion: `Tab`, `<C-Space>`, `<C-j/k>`, `<C-h>`
5. Refactoring: `<leader>rn`, `<leader>ca`, `gi`
6. Git hunks, Trouble, formatting, then anything advanced

Make each stage automatic before starting the next.
