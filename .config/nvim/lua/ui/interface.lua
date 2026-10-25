require("vim._core.ui2").enable()

vim.opt.winborder = "rounded"

vim.pack.add({
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/nvim-mini/mini.pick",
  "https://github.com/nvim-mini/mini.clue",
  "https://github.com/nvim-mini/mini.extra",
  "https://github.com/nvim-mini/mini.visits",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/m4xshen/hardtime.nvim",
  "https://github.com/tris203/precognition.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
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
  triggers = require("keybindings").clue_triggers,
  clues = require("keybindings").clues(miniclue),

  window = {
    config = {
      border = "rounded",
      width = math.floor(0.3 * vim.o.columns),
    },
    delay = 0,
  },
})

-- File explorer
require("nvim-tree").setup({
  view = {
    width = 25,
    side = "left",
  },
})

-- nvim suggestions
require("precognition").setup({
  targetedMotionHints = {
    enabled = false,
  },
})

require("hardtime").setup({
  restriction_mode = "hint",
  timeout = 10000,
  disable_mouse = false,
  disabled_keys = {
    ["<Up>"] = false,
    ["<Down>"] = false,
    ["<Left>"] = false,
    ["<Right>"] = false,
  },
})
