vim.pack.add({ "https://github.com/jake-stewart/multicursor.nvim" })

local mc = require("multicursor-nvim")
mc.setup()

require("keybind").setup_multicursor(mc)
