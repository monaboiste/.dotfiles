vim.g.mapleader = " "

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Fold
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Show numer lines
vim.opt.number = true
vim.opt.relativenumber = true

-- QOL
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 16 -- keep cursor away from the screen edge
vim.opt.undofile = true -- persistent undo history across sessions
vim.opt.swapfile = true
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

require("keybindings").setup()
require("ui.styling")
require("ui.interface")
require("markdown")
require("lsp")

vim.schedule(function()
  require("git")
end)

vim.schedule(function()
  require("multicursor")
end)
