# Components

Paths are relative to `lua/`. Plugin specs live in `plugins/`.

## Plugins

| Component | Purpose | Configured in |
| --- | --- | --- |
| lazy.nvim | Plugin manager (quiet update checker on; personal lockfile) | `config/lazy.lua`, `util/lockfile.lua` |
| nvim-lspconfig | LSP server definitions | `plugins/lsp.lua` |
| mason.nvim | Installs LSPs and tools | `plugins/lsp.lua` |
| mason-lspconfig | Installs servers, enables those in the language table | `plugins/lsp.lua` |
| mason-tool-installer | Auto-installs formatters/tools | `plugins/lsp.lua` |
| Trouble | Diagnostics/references panel | `plugins/lsp.lua` |
| nvim-cmp (+ cmp-nvim-lsp, cmp-buffer, cmp-path, cmp-cmdline, cmp_luasnip) | Completion popup | `plugins/completion.lua` |
| LuaSnip + friendly-snippets | Snippets | `plugins/completion.lua` |
| nvim-treesitter (`master` branch) | Syntax parsing, highlighting, indent | `plugins/treesitter.lua` |
| Telescope + plenary + fzf-native | Fuzzy finding, live grep (fzf-native is loaded as an extension) | `plugins/telescope.lua` |
| Conform | Formatting, format on save | `plugins/formatting.lua` |
| Gitsigns | Git gutter and hunks | `plugins/git.lua` |
| mini.ai | Extra text objects | `plugins/textobjects.lua` |
| mini.pairs | Auto-close brackets and quotes | `plugins/textobjects.lua` |
| which-key | Keybinding discovery | `plugins/textobjects.lua` |
| nvim-tree | File explorer | `plugins/ui.lua` |
| lualine | Statusline and buffer tabline | `plugins/ui.lua` |
| TokyoNight (night) | Theme | `plugins/ui.lua` |
| nvim-web-devicons | Icons | `plugins/ui.lua` |
| toggleterm.nvim | Integrated terminal | `plugins/terminal.lua` |

Non-plugin code: `config/languages.lua` (language table) with
`util/languages.lua` (derives plugin lists), `util/cheatsheet.lua`
(generator, started from `init.lua`), `config/leader_groups.lua` (namespace
labels), `util/user.lua` (loads your `lua/user/` files), `util/welcome.lua`
(first-run install window, `:EliteInfo`), `util/lockfile.lua` (personal plugin
lockfile, `:EliteLockReset`), `elite/health.lua` (`:checkhealth elite`).

Scripts (`scripts/`): `install.sh`, `uninstall.sh`, `update.sh`,
`user-layer.sh`, `generate-cheatsheet.sh`. See [INSTALL.md](INSTALL.md).

## Language support

The source of truth is `lua/config/languages.lua` (defaults) plus your own
`lua/config/languages_local.lua`; this table is a snapshot of the defaults. To add a language see [ADDING_LANGUAGES.md](ADDING_LANGUAGES.md).

| Language | LSP | Formatter | Tree-sitter |
| --- | --- | --- | --- |
| C / C++ | clangd | clang-format | c, cpp |
| Python | basedpyright | ruff | python |
| Lua | lua_ls | stylua | lua, vim, vimdoc |
| Rust | rust_analyzer | rustfmt | rust |
| Bash / sh | bashls | shfmt | bash |
| JS / TS / React | ts_ls | prettier | javascript, typescript, tsx |
| JSON / YAML | none | prettier | json, yaml |
| Markdown | none | prettier | markdown, markdown_inline |

Anything else (Go, HTML/CSS, TOML, Java, ...) is opt-in through
`config/languages_local.lua`.

`auto_install` fetches other parsers on demand. Formatter tools install via
mason-tool-installer. Without a formatter, Conform falls back to LSP
formatting. Only servers in the language table are enabled. `lua_ls` is scoped
to files inside the Neovim config directory.

## VS Code equivalents

| VS Code | Here |
| --- | --- |
| IntelliSense | LSP + nvim-cmp |
| Parameter hints | Signature help (`<C-s>` in insert) |
| Hover docs | `K` |
| Go to definition / references | `gd` / `gr` |
| Rename / quick fix | `<leader>rn` / `<leader>ca` |
| Problems panel | Trouble (`<leader>xx`) |
| Quick open / search in files | `<leader>ff` / `<leader>fg` |
| Sidebar explorer | nvim-tree (`<leader>e`) |
| Open editors / tabs | Buffer tabline along the top (`H` / `L`) |
| Format document | `<leader>cf`, and on save |
| Source control gutter | Gitsigns |
| Snippets | LuaSnip |
| Integrated terminal | toggleterm (`<C-\>`) |
| Command palette | `<leader>fc` |
| Save | `<C-s>` |
