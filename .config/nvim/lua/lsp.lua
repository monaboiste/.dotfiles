vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/stevearc/conform.nvim",
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "bashls",
  },
})
require("mason-tool-installer").setup({
  ensure_installed = {
    "stylua",
    "shellcheck",
    "shfmt",
    "sqlfluff",
  },
})

vim.lsp.config("bashls", {
  filetypes = { "sh", "bash", "zsh" },
  settings = {
    bashIde = {
      shellcheckArguments = { "--shell=bash" },
    },
  },
})
vim.lsp.enable({
  "lua_ls",
  "bashls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp.userlsp", { clear = true }),
  callback = function(args)
    vim.keymap.set(
      "n",
      "<leader>ca",
      vim.lsp.buf.code_action,
      { desc = "Code action", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>cR",
      vim.lsp.buf.rename,
      { desc = "Rename", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>cs",
      "<cmd> lua MiniExtra.pickers.lsp({ scope = 'document_symbol' })<cr>",
      { desc = "Symbols", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>cl",
      "<cmd> lua MiniExtra.pickers.lsp({ scope = 'definition' })<cr>",
      { desc = "Definition", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>cr",
      "<cmd> lua MiniExtra.pickers.lsp({ scope = 'references' })<cr>",
      { desc = "References", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>K",
      vim.lsp.buf.hover,
      { desc = "Show", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>gD",
      vim.lsp.buf.declaration,
      { desc = "Goto declaration", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>gd",
      vim.lsp.buf.definition,
      { desc = "Goto definition", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>gi",
      vim.lsp.buf.implementation,
      { desc = "Goto implementation", buffer = args.buf }
    )
  end,
})

-- Diagnostics
vim.diagnostic.config({
  virtual_text = { spacing = 2 },
  severity_sort = true,
})
vim.cmd([[ set completeopt+=menuone,noselect,popup ]])

-- Completions
require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<tab>"] = { "accept", "fallback" },
    ["<C><Space>"] = { "show" },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  completion = { documentation = { auto_show = false } },

  fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Formatters
local conform = require("conform")
conform.setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    sql = { "sqlfluff" },
  },
  formatters = {
    sqlfluff = {
      args = { "format", "--dialect", "oracle", "-" },
    },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format" })
