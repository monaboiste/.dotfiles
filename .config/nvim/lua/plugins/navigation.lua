return {
  -- File finder
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim", {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
      }
    },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>f", builtin.find_files, {})
      vim.keymap.set("n", "<C-S>", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>b", builtin.buffers, {})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
    end
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
    config = function()
      vim.keymap.set("n", "<leader>n", ":Neotree filesystem toggle left<CR>")
    end
  }
}