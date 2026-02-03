vim.g.mapleader = " "

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Show numer lines
vim.opt.number = true
vim.opt.relativenumber = true

-- Show whitespaces
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  tab = "->",
}

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

-- Theme
local bg_color_override = "#23232b"

vim.pack.add({ "https://github.com/catppuccin/nvim" })
require("catppuccin").setup({
  transparent_background = true,
  color_overrides = {
    all = {
      base = bg_color_override,
      mantle = bg_color_override,
      crust = bg_color_override
    },
  },
  integrations = { lualine = { enabled = true } },
})
vim.cmd.colorscheme("catppuccin-mocha")

vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
require("lualine").setup({
  options = {
    theme = "catppuccin",
    section_separators = "",
    component_separators = "",
    globalstatus = true,
  },
  winbar = {
    lualine_a = {
      { "filename", color = { fg = "grey", bg = "none" } }
    },
  },
  sections = {
    lualine_a = {
      "mode",
      {
        function()
          local reg = vim.fn.reg_recording()
          if reg == "" then return "" end
          return "⏺ " .. reg
        end,
        cond = function() return vim.fn.reg_recording() ~= "" end,
        color = { fg = "#23232b", gui = "bold" }
      }
    },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {},
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" }
  },
  inactive_winbar = {
    lualine_c = { "filename" }
  }
})

