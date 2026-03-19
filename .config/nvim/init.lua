vim.g.mapleader = " "

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Show numer lines
vim.opt.number = true
vim.opt.relativenumber = true

-- QOL
vim.opt.undofile = true -- persistent undo history
vim.opt.swapfile = false
vim.opt.wrap = false

-- Clear last search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Copy to system clipboard
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-c>", 'V"+y')

-- Jump by n lines
vim.keymap.set("n", "<C-d>", "5j", { desc = "Jump down by 5 lines" })
vim.keymap.set("n", "<C-u>", "5k", { desc = "Jump up by 5 lines" })

-- Scroll by n lines
vim.keymap.set("n", "<C-e>", "10<C-e>", { desc = "Scroll down by 10 lines" })
vim.keymap.set("n", "<C-y>", "10<C-y>", { desc = "Scroll up by 10 lines" })

require("ui.styling")
require("ui.interface")
require("tmux")
require("lsp")
require("multicursor")
