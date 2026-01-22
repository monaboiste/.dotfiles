require("config.lazy")

-- Indent
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Show numer lines
vim.cmd("set number")

-- Show whitespaces
vim.cmd("set listchars=space:·,tab:->\\ ")
vim.cmd("set list")

-- Copy yanked selection to clipboard
vim.cmd("set clipboard=unnamedplus")

-- Theme
vim.cmd.colorscheme "catppuccin"

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

