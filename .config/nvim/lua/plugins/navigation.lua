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
      { "<leader><leader>", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" }
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
  }
}
