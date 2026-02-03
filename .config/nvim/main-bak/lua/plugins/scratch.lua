return {
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    dependencies = {
      "ibhagwan/fzf-lua"
    },
    keys = {
      { "<leader>sn", "<cmd>Scratch<cr>",     desc = "New scratch file" },
      { "<leader>so", "<cmd>ScratchOpen<cr>", desc = "Open scratch file" },
      { "<leader>sf", "<cmd>ScratchOpenFzf<cr>", desc = "Find scratch file" },
    }
  }
}
