vim.pack.add({ "https://github.com/jake-stewart/multicursor.nvim" })

local mc = require("multicursor-nvim")
mc.setup()

require("keybindings").setup_multicursor(mc)
