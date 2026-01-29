require("config.lazy")

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Show numer lines
vim.opt.number = true
vim.opt.relativenumber = true

-- Hide statusline (we're using winbar)
vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.showmode = false

-- Show whitespaces
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  tab = "->",
}

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- Start with everything open

-- QOL
vim.opt.clipboard = "unnamedplus" -- copy yanked selection to system clipboard
vim.opt.undofile = true           -- persistent undo history
vim.opt.swapfile = false
vim.opt.wrap = false

-- Panes navigation to better fit tmux convention
vim.keymap.set("n", '<leader>w"', ":split<cr>", { desc = "Split horizontally" })
vim.keymap.set("n", '<leader>w%', ":vsplit<cr>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>wq", ":quit<cr>", { desc = "Close" })

-- Jump by n lines
vim.keymap.set("n", "<C-]>", "5j", { desc = "Jump down by 5 lines" })
vim.keymap.set("n", "<C-[>", "5k", { desc = "Jump up by 5 lines" })

