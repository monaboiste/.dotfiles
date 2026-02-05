vim.opt.winborder = "rounded"

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/folke/which-key.nvim",
})

-- Picker
local fzf = require("fzf-lua")
fzf.setup({
  winopts = {
    height = 0.90,
    width = 0.90,
    preview = {
      layout = "vertical",
      vertical = "up:60%",
    },
  },
  fzf_opts = {
    ["--tiebreak"] = "index",
  },
})

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })
vim.keymap.set(
  "n",
  "<leader>fb",
  fzf.buffers,
  { desc = "Find in Open Buffers" }
)
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "Find Command" })

-- "What to press next" overlay
local wk = require("which-key")
wk.setup({ preset = "helix" })

vim.keymap.set("n", "<leader>?", function()
  wk.show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>w", group = "Windows" },
  { "<leader>c", group = "Code (LSP)" },
})
