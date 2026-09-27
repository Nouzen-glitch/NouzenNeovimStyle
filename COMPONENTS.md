# Component record

| Component | Purpose | Where configured |
|---|---|---|
| lazy.nvim | Plugin manager | `lua/config/lazy.lua` |
| nvim-lspconfig | LSP server configurations | `lua/plugins/lsp.lua` |
| mason.nvim | Installs external tools/LSPs | `lua/plugins/lsp.lua` |
| mason-lspconfig | Bridges Mason and LSP enablement | `lua/plugins/lsp.lua` |
| clangd | C/C++ IntelliSense | Mason |
| basedpyright | Python IntelliSense/type checking | Mason |
| rust-analyzer | Rust IntelliSense | Mason |
| lua-language-server | Lua IntelliSense | Mason |
| bash-language-server | Bash IntelliSense | Mason |
| nvim-cmp | Completion popup | `lua/plugins/completion.lua` |
| LuaSnip | Snippets | `lua/plugins/completion.lua` |
| friendly-snippets | VS Code-style snippet collection | `lua/plugins/completion.lua` |
| nvim-treesitter | Syntax parsing/highlighting | `lua/plugins/treesitter.lua` |
| Telescope | Fuzzy finding/search | `lua/plugins/telescope.lua` |
| nvim-tree | File explorer | `lua/plugins/ui.lua` |
| Trouble | Diagnostics/references panel | `lua/plugins/lsp.lua` |
| Gitsigns | Git hunks/gutter | `lua/plugins/git.lua` |
| Conform | Formatting | `lua/plugins/formatting.lua` |
| mini.ai | Powerful text objects | `lua/plugins/textobjects.lua` |
| which-key | Discover keybindings | `lua/plugins/textobjects.lua` |
| lualine | Statusline | `lua/plugins/ui.lua` |
| TokyoNight | Theme | `lua/plugins/ui.lua` |

## Core VS Code replacements

- IntelliSense: LSP + nvim-cmp
- Function argument/signature panel: LSP signature help
- Documentation: LSP hover (`K`)
- Go to definition: `gd`
- References: `gr`
- Rename: `<leader>rn`
- Code actions: `<leader>ca`
- Error highlighting: LSP diagnostics
- Error list: Trouble (`<leader>xx`)
- Syntax highlighting: Tree-sitter
- Project search: Telescope (`<leader>fg`)
- File search: Telescope (`<leader>ff`)
- File tree: nvim-tree (`<leader>e`)
- Formatting: Conform (`<leader>f`)
- Git gutter: Gitsigns
- Snippets: LuaSnip
