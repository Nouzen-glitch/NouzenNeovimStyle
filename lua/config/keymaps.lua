local map = vim.keymap.set

-- Your own mappings go in lua/user/keymaps.lua (loaded after this file).

-- ============================================================================
-- Vim fundamentals
-- ============================================================================

-- Leave Insert mode without reaching for Escape.
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Arrow-key ban: learn real Vim movement.
-- Opt out in lua/user/options.lua:  vim.g.elite_disable_arrows = false
if vim.g.elite_disable_arrows ~= false then
    for _, mode in ipairs({ "n", "i", "v" }) do
        map(mode, "<Up>", "<Nop>")
        map(mode, "<Down>", "<Nop>")
        map(mode, "<Left>", "<Nop>")
        map(mode, "<Right>", "<Nop>")
    end
end

-- Keep search results centered.
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Move through wrapped display lines naturally.
map("n", "j", "gj", { desc = "Down display line" })
map("n", "k", "gk", { desc = "Up display line" })

-- Keep visual selections after indenting.
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Small comforts.
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<C-s>", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centered" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("x", "p", [["_dP]], { desc = "Paste without overwriting register" })

-- ============================================================================
-- Windows
-- ============================================================================

map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

map("n", "<leader>ww", "<C-w>w", { desc = "Cycle windows" })
map("n", "<leader>wd", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })

-- ============================================================================
-- Buffers
-- ============================================================================

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- ============================================================================
-- LSP
-- ============================================================================

map("n", "K", vim.lsp.buf.hover, { desc = "LSP hover documentation" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "<leader>ds", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
map("n", "<leader>ih", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- Diagnostics.
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>dq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })

-- Signature help in Insert mode is Neovim's built-in <C-s> (0.11+). A custom
-- <C-h> mapping is avoided because many terminals send <C-h> for Backspace.

-- ============================================================================
-- Telescope
-- ============================================================================

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Search project" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Search help" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
map("n", "<leader>fC", "<cmd>Cheatsheet<cr>", { desc = "Open generated cheatsheet" })

-- Discover all globally registered keybindings with which-key.
map("n", "<leader>?", function()
    require("which-key").show({ global = true })
end, { desc = "Show all keybindings" })

-- ============================================================================
-- Explorer / diagnostics / formatting
-- ============================================================================

map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics panel" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })

map({ "n", "v" }, "<leader>cf", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end, { desc = "Format file/selection" })

-- ============================================================================
-- Git
-- ============================================================================

map("n", "]h", function() require("gitsigns").next_hunk() end, { desc = "Next git hunk" })
map("n", "[h", function() require("gitsigns").prev_hunk() end, { desc = "Previous git hunk" })
map("n", "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
map("n", "<leader>hr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
map("n", "<leader>hp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })

-- ============================================================================
-- Terminal
-- ============================================================================

map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })
