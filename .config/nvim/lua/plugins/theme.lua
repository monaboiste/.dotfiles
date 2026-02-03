local bg_color_override = "#23232b"
return {
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent_background = true,
      color_overrides = {
        all = {
          base = bg_color_override,
          mantle = bg_color_override,
          crust = bg_color_override
        }
      },
      integrations = { lualine = { enabled = true } }
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end
  },

  -- Statusbar
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        section_separators = "",
        component_separators = "",
        globalstatus = true,
        ignore_focus = { "nvim-tree" }
      },
      winbar = {
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
}

