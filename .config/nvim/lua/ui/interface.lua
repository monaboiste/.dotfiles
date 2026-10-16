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
  "https://github.com/nvim-mini/mini.visits",
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

require("mini.extra").setup()
require("mini.visits").setup()

-- "What to press next" overlay
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = require("keybind").clue_triggers,
  clues = require("keybind").clues(miniclue),

  window = {
    config = {
      border = "rounded",
      width = math.floor(0.3 * vim.o.columns),
    },
    delay = 0,
  },
})
