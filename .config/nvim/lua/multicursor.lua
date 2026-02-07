vim.pack.add({ "https://github.com/jake-stewart/multicursor.nvim" })

local mc = require("multicursor-nvim")
mc.setup()

vim.keymap.set("x", "<M-S-Up>", function()
  mc.lineAddCursor(-1)
end, { desc = "Add cursor up" })
vim.keymap.set("x", "<M-S-Down>", function()
  mc.lineAddCursor(1)
end, { desc = "Add cursor down" })

vim.keymap.set({ "n", "x" }, "<C-g>", function()
  mc.matchAddCursor(1)
end, { desc = "Add cursor by matching word/selection" })
vim.keymap.set({ "n", "x" }, "<C-M-g>", function()
  mc.matchSkipCursor(1)
end, { desc = "Skip cursor by matching word/selection" })

vim.keymap.set("n", "<C-LeftMouse>", mc.handleMouse, { desc = "Add cursors" })
vim.keymap.set(
  "n",
  "<C-LeftDrag>",
  mc.handleMouseDrag,
  { desc = "Add cursors" }
)
vim.keymap.set(
  "n",
  "<C-LeftRelease>",
  mc.handleMouseRelease,
  { desc = "Remove cursors" }
)

vim.keymap.set(
  "n",
  "<leader>cv",
  mc.restoreCursors,
  { desc = "Restore cleared cursors" }
)

mc.addKeymapLayer(function(layerSet)
  -- Enable and clear cursors using escape.
  layerSet("n", "<esc>", function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)
