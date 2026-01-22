require("config.lazy")

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Show numer lines
vim.opt.number = true

-- Show whitespaces
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  tab = "->",
}

-- Copy yanked selection to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- Start with everything open
