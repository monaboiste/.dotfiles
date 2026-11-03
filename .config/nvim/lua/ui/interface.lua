require("vim._core.ui2").enable()

vim.opt.winborder = "rounded"

vim.pack.add({
  "https://github.com/rcarriga/nvim-notify",
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

-- Notifications
local notify = require("notify")
notify.setup({
  timeout = 6000,
  background_colour = "#000000",
  render = "compact",
  stages = "fade_in_slide_out",
})
vim.notify = notify

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
  highlightColor = { link = "Comment" },
  targetedMotionHints = {
    enabled = false,
  },
})

require("hardtime").setup({
  restriction_mode = "hint",
  timeout = 5000,
  max_count = 2,
  disable_mouse = false,
  restricted_keys = {
    ["<Up>"] = { "n", "x", "i" },
    ["<Down>"] = { "n", "x", "i" },
    ["<Left>"] = { "n", "x", "i" },
    ["<Right>"] = { "n", "x", "i" },
  },
  disabled_keys = {
    ["<Up>"] = false,
    ["<Down>"] = false,
    ["<Left>"] = false,
    ["<Right>"] = false,
  },
  callback = function(message)
    local suggestions = {
      ["<Up>"] = "Try k, 5k or Ctrl-U instead of Up",
      ["<Down>"] = "Try j, 5j or Ctrl-D instead of Down",
      ["<Left>"] = "Try h, 5h or b instead of Left",
      ["<Right>"] = "Try l, 5l or w instead of Right",
    }

    local key = message:match("^You pressed the (.-) key too soon!")

    vim.notify(
      suggestions[key] or message,
      vim.log.levels.WARN,
      { title = "Hardtime", timeout = 5000 }
    )
  end,
})
