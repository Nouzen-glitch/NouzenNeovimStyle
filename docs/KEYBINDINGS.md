# Keybindings

Custom bindings from `lua/config/keymaps.lua` and plugin configs. Leader is
**Space**. For the live, complete list (including built-ins and plugin
defaults) use `<leader>?`, `<leader>fk`, or the generated cheatsheet
(`<leader>fC` / `:Cheatsheet`). Your own bindings go in `lua/user/keymaps.lua`
([MIGRATING.md](MIGRATING.md)).

## Your own keys

They go in `lua/user/keymaps.lua` (`:EliteEdit keymaps` creates and opens it).
Give every mapping a `desc`: that is what shows in `<leader>?`, `<leader>fk` and
the generated cheatsheet (which covers normal, visual, operator-pending, insert,
terminal and command-line maps, plus buffer-local maps). This file lists only
the shipped keys.

- **Same key, yours wins.** It replaces the shipped one; the action can still be
  run as a command (`<leader>fc`) or moved to another key in the same file.
- **You are told.** `:EliteKeys` and `:checkhealth elite` list every shipped key
  you replaced, removed or shadowed, and Neovim shows a one-time notice at
  startup whenever that list changes.
- **Prefix delay.** If one of your keys is the start of a longer shipped key
  (yours `<leader>f`, shipped `<leader>ff`), or extends one, the *shorter* key
  waits `timeoutlen` (400 ms) to see whether you type more. Avoid prefixes.
- **Plugin keys can win.** `<C-\>` is set by toggleterm after your keymaps load;
  rebind it through toggleterm's `opts` ([MIGRATING.md](MIGRATING.md), section 4).
  Likewise `jk`, `<Esc>` and `<C-h/j/k/l>` in Terminal mode are set per toggleterm
  buffer, so a global Terminal-mode map of yours on those keys is shadowed there
  (and `:EliteKeys` does not report it). Other terminals are not affected.
- **Your own prefix labels.** `vim.g.elite_leader_groups = { g = "Git" }` in
  `lua/user/options.lua` names a new prefix in which-key and the cheatsheet.

Keys worth checking before you override them: `jk`, `<C-s>`, `<C-h/j/k/l>`,
`<C-d>`, `<C-u>`, `H`, `L`, `K`, `gd`, `gr`, `n`, `N`, `<Esc>`, `<C-\>`, and
anything starting with `<leader>f`, `<leader>w` or `<leader>c`.

## Fundamentals

| Key | Mode | Action |
| --- | --- | --- |
| `jk` | i, t | Leave Insert mode; leave Terminal mode in the toggleterm terminal (other terminals keep `jk` for the program) |
| Arrow keys | n, i, v | Disabled (`<Nop>`). Opt out: `vim.g.elite_disable_arrows = false` in `lua/user/options.lua` |
| `j` / `k` | n | Move by display line (wrapped lines) |
| `n` / `N` | n | Next / previous search result, centered |
| `<` / `>` | v | Indent and keep selection |
| `<Esc>` | n | Clear search highlight |
| `<C-s>` | n | Save file |
| `<leader>q` | n | Quit window |
| `<C-d>` / `<C-u>` | n | Half page down / up, cursor centered |
| `J` / `K` | v | Move selected lines down / up |
| `p` | x | Paste over a selection without losing what you yanked |

## Windows and buffers

| Key | Action |
| --- | --- |
| `<C-h/j/k/l>` | Focus left / down / up / right window |
| `<leader>wv` / `<leader>ws` | Vertical / horizontal split |
| `<leader>wd` | Close window |
| `<leader>ww` | Cycle windows |
| `H` / `L` | Previous / next buffer (open buffers are shown along the top) |
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
| `<C-s>` (insert) | Signature help (Neovim built-in) |

Neovim 0.11+ also provides defaults: `grn` rename, `gra` code action, `grr`
references, `gri` implementation, `grt` type definition, `gO` symbols,
`<C-s>` (insert/select) signature help.

Because `gr` is also mapped here, a lone `gr` waits `timeoutlen` (400 ms) in case
you are typing one of the longer defaults (`grr`, `gra`, `grn`, ...). `grr` works
at full speed.

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
| `<leader>fi` | Elite guide (`:EliteHelp`) |
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
brackets). `mini.pairs` closes brackets and quotes as you type. Built-ins used
constantly: `ciw`, `ci"`, `ci(`, `da{`, `yiw`. `gcc` toggles a comment, `gc` +
motion/selection comments a range.

## Leader namespaces

`f` Find, `w` Windows, `x` Diagnostics list, `h` Git hunks,
`b` Buffers, `c` Code (actions, format), `d` Diagnostic details (and `<leader>ds` document symbols),
`i` Inlay hints, `r` Rename. Press `<leader>` and wait for which-key.

## Learning order

1. Insert/leave (`i a o`, `jk`), `hjkl`, `w b e`, `0 ^ $`, `dd yy p u <C-r>`
2. Operators plus text objects: `d c y` with `iw aw i" i( i{`
3. Navigation: `<leader>ff`, `<leader>fg`, `gd`, `gr`, `K`
4. Completion: `Tab`, `<C-Space>`, `<C-j/k>`, `<C-s>` for signatures
5. Refactoring: `<leader>rn`, `<leader>ca`, `gi`
6. Git hunks, Trouble, formatting, then anything advanced

Make each stage automatic before starting the next.
