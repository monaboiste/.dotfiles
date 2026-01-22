return {
  { 
    -- Colorscheme
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      color_overrides = {
        all = {
          base = "#23232b",
          mantle = "#23232b",
          crust = "#23232b"
         }
      }
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  }, 
  { -- Syntax highlighting
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

