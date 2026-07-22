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
vim.opt.clipboard = "unnamedplus" -- copy to clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]]) -- pasting over a selection no longer clobbers the clipboard

--
-- Keymaps

-- Clear last search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Copy to system clipboard
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-c>", 'V"+y')

-- Jump by n lines
vim.keymap.set("n", "<C-d>", "5j", { desc = "Jump down by 5 lines" })
vim.keymap.set("n", "<C-e>", "5k", { desc = "Jump up by 5 lines" })

-- Tabs and panes
vim.keymap.set("n", '<leader>t"', ":split<cr>", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>t%", ":vsplit<cr>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>tq", ":quit<cr>", { desc = "Close" })
vim.keymap.set("n", "<leader>tt", ":tabnew<cr>", { desc = "New Tab" })

-- Sort
vim.keymap.set({ "n", "x" }, "<leader>s", function()
  if vim.fn.mode():match("[vV\22]") then
    vim.cmd("'<,'>sort")
  else
    vim.cmd("%sort")
  end
end, { desc = "Sort selection or file" })

require("ui.styling")
require("ui.interface")
require("lsp")
require("multicursor")
