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
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 16 -- keep cursor away from the screen edge
vim.opt.undofile = true -- persistent undo history across sessions
vim.opt.swapfile = false
vim.opt.wrap = false

-- Create missing directories before file is saved
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

require("keybind").setup()
require("ui.styling")
require("ui.interface")
require("git")
require("lsp")
require("multicursor")
