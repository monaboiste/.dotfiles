require("config.lazy")

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Show numer lines
vim.opt.expandtab = true

-- Show whitespaces
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  tab = "-> ",
}

-- Copy yanked selection to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Theme
vim.cmd.colorscheme("catppuccin")

-- Navigation
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, {
  desc = "Find files"
 })
vim.keymap.set("n", "<C-S>", builtin.live_grep, {
  desc = "Live grep"
 })
vim.keymap.set("n", "<leader>b", builtin.buffers, {
  desc = "Buffers"
 })

vim.keymap.set("n", "<leader>n", ":Neotree filesystem toggle left<CR>")

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- Start with everything open

