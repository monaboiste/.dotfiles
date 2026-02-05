vim.opt.winborder = "rounded"

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/folke/trouble.nvim",
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

-- Trouble

require("trouble").setup({
  auto_close = true,
  restore_window = false,
})

vim.keymap.set(
  "n",
  "<leader>xx",
  "<cmd>Trouble diagnostics toggle<cr>",
  { desc = "Diagnostics" }
)
vim.keymap.set(
  "n",
  "<leader>xX",
  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "Buffer Diagnostics" }
)
vim.keymap.set(
  "n",
  "<leader>cs",
  "<cmd>Trouble symbols toggle focus=false<cr>",
  { desc = "Symbols" }
)
vim.keymap.set(
  "n",
  "<leader>cl",
  "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "LSP Definitions/refs" }
)
vim.keymap.set(
  "n",
  "<leader>xL",
  "<cmd>Trouble loclist toggle<cr>",
  { desc = "Location List" }
)
vim.keymap.set(
  "n",
  "<leader>xQ",
  "<cmd>Trouble qflist toggle<cr>",
  { desc = "Quickfix List" }
)

local config = require("fzf-lua.config")
local actions = require("trouble.sources.fzf").actions
config.defaults.actions.files["ctrl-t"] = actions.open -- in fzf-lua hit <c-t> to open trouble

-- "What to press next" overlay
local wk = require("which-key")
wk.setup({ preset = "helix" })

vim.keymap.set("n", "<leader>?", function()
  wk.show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

wk.add({
  { "<leader>c", group = "Code (LSP)" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Goto" },
  { "<leader>w", group = "Windows" },
  { "<leader>x", group = "Trouble" },
})
