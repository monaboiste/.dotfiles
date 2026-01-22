return {
  -- File finder
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader><leader>", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>rr", "<cmd>Telescope registers<cr>", desc = "View Macros" }
    }
  },
  -- File browser
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false
        }
      }
    },
    keys = {
      { "<leader>n", "<cmd>Neotree filesystem toggle left<cr>", desc = "Toggle File Browser" }
    }
  },
  -- "What to press next" overlay
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      preset = "helix"
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)"
      }
    }
  }
}
