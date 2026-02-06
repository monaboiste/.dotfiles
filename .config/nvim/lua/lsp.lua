local registry = {
  lua = {
    servers = { "lua_ls" },
    tools = { "stylua" },
    formatters = { "stylua" },
  },
  sh = {
    servers = { "bashls" },
    tools = { "shellcheck", "shfmt" },
    formatters = { "shfmt" },
  },
  zsh = {
    servers = { "bashls" },
    tools = { "shellcheck", "shfmt" },
    formatters = { "shfmt" },
  },
  sql = {
    tools = { "sqlfluff" },
    formatters = {
      sqlfluff = {
        args = { "format", "--dialect", "oracle", "-" },
      },
    },
  },
}

local servers = {}
local tools = {}
local formatters_by_ft = {}
local custom_formatter_configs = {}

for ft, cfg in pairs(registry) do
  if cfg.servers then
    for _, s in ipairs(cfg.servers) do
      table.insert(servers, s)
    end
  end

  if cfg.tools then
    for _, t in ipairs(cfg.tools) do
      table.insert(tools, t)
    end
  end

  if cfg.formatters then
    formatters_by_ft[ft] = {}

    for key, value in pairs(cfg.formatters) do
      if type(key) == "number" then
        table.insert(formatters_by_ft[ft], value)
      else
        table.insert(formatters_by_ft[ft], key)
        custom_formatter_configs[key] = value
      end
    end
  end
end

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/stevearc/conform.nvim",
})

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = servers })
require("mason-tool-installer").setup({ ensure_installed = tools })

vim.api.nvim_create_autocmd("LspAttach", {
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
    vim.keymap.set("n", "<leader>cs", function()
      ---@diagnostic disable-next-line: undefined-global
      MiniExtra.pickers.lsp({ scope = "document_symbol" })
    end, { desc = "Symbols" })
    vim.keymap.set("n", "<leader>cl", function()
      ---@diagnostic disable-next-line: undefined-global
      MiniExtra.pickers.lsp({ scope = "definition" })
    end, { desc = "Definition" })
    vim.keymap.set("n", "<leader>cr", function()
      ---@diagnostic disable-next-line: undefined-global
      MiniExtra.pickers.lsp({ scope = "references" })
    end, { buffer = args.buf, desc = "References" })
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

for _, server in ipairs(servers) do
  local cfg = vim.lsp.config[server]
  vim.lsp.config(server, cfg)
  vim.lsp.enable(server)
end

-- Diagnostics
vim.diagnostic.config({ virtual_text = true })
vim.cmd([[ set completeopt+=menuone,noselect,popup ]])

-- Completions
require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<tab>"] = { "accept", "fallback" },
    ["<C><leader>"] = { "show" },
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
  formatters_by_ft = formatters_by_ft,
  formatters = custom_formatter_configs,
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
