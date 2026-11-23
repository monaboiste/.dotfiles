vim.pack.add({ "https://github.com/nvim-mini/mini.surround" })

require("mini.surround").setup({
  mappings = require("keybindings").surround,
})
