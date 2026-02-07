--[[
-- Notes: some of the dependencies are tightly
-- coupled to lsp.lua.
]]

vim.opt.winborder = "rounded"

vim.pack.add({
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/nvim-mini/mini.pick",
  "https://github.com/nvim-mini/mini.clue",
  "https://github.com/nvim-mini/mini.extra",
})

-- Icons
require("mini.icons").setup()

-- Picker
local pick = require("mini.pick")

pick.setup({
  window = {
    config = {
      height = math.floor(0.2 * vim.o.lines),
      width = math.floor(0.5 * vim.o.columns),
    },
  },
})

vim.keymap.set("n", "<leader><leader>", function()
  -- Override picking command with ripgrep and include hidden files
  pick.builtin.cli({
    command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
  })
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fb", function()
  pick.builtin.buffers()
end, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fg", function()
  pick.builtin.grep_live()
end, { desc = "Live Grep" })
vim.keymap.set(
  "n",
  "<leader>fc",
  "<cmd> lua MiniExtra.pickers.history({ scope = ':'})<cr>",
  { desc = "Find Command" }
)

vim.keymap.set(
  "n",
  "<leader>fr",
  "<cmd> lua MiniExtra.pickers.registers()<cr>",
  { desc = "Registers" }
)

-- Trouble
require("mini.extra").setup()

vim.keymap.set(
  "n",
  "<leader>xx",
  "<cmd>lua MiniExtra.pickers.diagnostic()<cr>",
  { desc = "Diagnostics" }
)
vim.keymap.set(
  "n",
  "<leader>xX",
  "<cmd>lua MiniExtra.pickers.diagnostic({ scope = 'current' })<cr>",
  { desc = "Buffer Diagnostics" }
)

-- "What to press next" overlay
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    { mode = { "n", "x" }, keys = "<leader>" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "n", keys = "g" },
    { mode = "n", keys = "z" },
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = { "n", "x" }, keys = '"' },
    { mode = "i", keys = "<C-x>" },
    { mode = "n", keys = "<C-w>" },
  },

  clues = {
    { mode = "n", keys = "<leader>c", desc = "+Code (LSP)" },
    { mode = "n", keys = "<leader>f", desc = "+Find" },
    { mode = "n", keys = "<leader>x", desc = "+Diagnostics" },
    { mode = "n", keys = "<leader>w", desc = "+Windows" },
    { mode = "n", keys = "<leader>g", desc = "+Goto" },

    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers({ show_contents = true }),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },

  window = {
    config = { border = "rounded", width = "auto" },
    delay = 0,
  },
})
