-- Show whitespaces
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  tab = "->",
}

-- Theme
local bg_color_override = "#23232b"

vim.pack.add({
  "https://github.com/catppuccin/nvim",
  "https://github.com/nvim-lualine/lualine.nvim"
})

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

-- Status line
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

