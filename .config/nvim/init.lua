require("config.lazy")

-- Indent
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.cmd("set number")

-- Color scheme
require("catppuccin").setup {
  color_overrides = {
    all = { base = "#23232b" }
  }
}

vim.cmd.colorscheme "catppuccin"
