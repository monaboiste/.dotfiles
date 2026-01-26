require("config.lazy")

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Show numer lines
vim.opt.number = true

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

-- Copy yanked selection to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Persistent undo history
vim.opt.undofile = true

-- Panes navigation to better fit tmux convention
vim.keymap.set("n", '<leader>w"', ":split<cr>", { desc = "Split horizontally" })
vim.keymap.set("n", '<leader>w%', ":vsplit<cr>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>wx", ":quit<cr>", { desc = "Close" })

