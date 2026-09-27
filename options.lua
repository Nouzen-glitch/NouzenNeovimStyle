-- Editor behavior / appearance.
-- Keep this file deliberately boring: editor fundamentals only.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.clipboard = "unnamedplus"

-- Faster, more readable command-line feedback.
vim.opt.showmode = false
vim.opt.laststatus = 3

-- Keep folds closed only when explicitly requested.
vim.opt.foldmethod = "manual"

-- Disable the mouse if you want a completely keyboard-only editor:
-- vim.opt.mouse = ""

-- netrw is disabled because nvim-tree is used as the explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
