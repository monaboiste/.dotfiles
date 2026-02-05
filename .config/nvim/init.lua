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
vim.opt.clipboard = "unnamedplus" -- copy yanked selection to system clipboard
vim.opt.undofile = true -- persistent undo history
vim.opt.swapfile = false
vim.opt.wrap = false

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>") -- clear last search highlighting

-- Jump by n lines
vim.keymap.set("n", "<C-]>", "5j", { desc = "Jump down by 5 lines" })
vim.keymap.set("n", "<C-[>", "5k", { desc = "Jump up by 5 lines" })

require("ui.styling")
require("ui.interface")
require("tmux")
require("lsp")
