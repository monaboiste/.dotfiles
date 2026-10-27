vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/Saghen/blink.lib",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/stevearc/conform.nvim",
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "bashls",
    "lemminx",
    "jsonls",
  },
})
require("mason-tool-installer").setup({
  ensure_installed = {
    "stylua",
    "shellcheck",
    "shfmt",
    "sqlfluff",
    "xmlformatter",
    "prettier",
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
vim.lsp.config("lemminx", {
  filetypes = { "xml", "xsd", "xslt", "svg" },
})

vim.lsp.enable({
  "lua_ls",
  "bashls",
  "lemminx",
  "jsonls",
})

-- Diagnostics
vim.diagnostic.config({
  virtual_text = { spacing = 2 },
  severity_sort = true,
})
vim.cmd([[ set completeopt+=menuone,noselect,popup ]])

-- Completions
local blink = require("blink.cmp")
blink.build():pwait(10000)
blink.setup({
  keymap = require("keybindings").blink,

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
    nix = { "nixfmt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    sql = { "sqlfluff" },
    xml = { "xmlformatter" },
    json = { "prettier" },
    jsonc = { "prettier" },
  },
  formatters = {
    sqlfluff = {
      args = { "format", "--dialect", "oracle", "-" },
      require_cwd = false,
    },
    xmlformatter = {
      command = "xmlformat",
      args = { "-" },
    },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
})
