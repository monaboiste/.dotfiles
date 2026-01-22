local bg_color_override = "#23232b"

return {
  -- Colorscheme
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      color_overrides = {
        all = {
          base = bg_color_override,
          mantle = bg_color_override,
          crust = bg_color_override
        }
      },
      integrations = {
        lualine = {
          enabled = true
        }
      }
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end
  }, 
  -- Statusbar
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        section_separators = "",
        component_separators = ""
       },
      winbar = {
        lualine_a = { 
          "mode",
          -- Macros workaround, see: https://github.com/nvim-lualine/lualine.nvim/issues/1355
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then return "" end
              return "⏺ " .. reg
            end,
            cond = function() return vim.fn.reg_recording() ~= "" end,
            color = { fg = bg_color_override, gui = "bold" }
          }
        },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" }
      },
      inactive_winbar = {
        lualine_c = { "filename" }
      }
    }
  }, 
  -- Syntax highlighting 
  {
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      opts = {
        ensure_installed = { "java", "javascript", "lua", "vim" }
      }
    }
  }
}

