local registry = {
  lua = {
    servers = { "lua_ls" },
    tools = { "stylua" },
    formatters = { "stylua" },
  },
  sh = {
    filetypes = { "sh", "bash", "zsh" },
    servers = {
      bashls = {
        settings = {
          bashIde = {
            shellcheckArguments = "--shell=bash",
          },
        },
      },
    },
    tools = { "shellcheck", "shfmt" },
    formatters = { "shfmt" },
  },
  sql = {
    tools = { "sqlfluff" },
    formatters = {
      sqlfluff = { args = { "format", "--dialect", "oracle", "-" } },
    },
  },
}

local servers_to_install = {}
local tools_to_install = {}
local formatters_by_ft = {}
local custom_formatter_configs = {}

for ft, cfg in pairs(registry) do
  if cfg.servers then
    for key, val in pairs(cfg.servers) do
      local name = type(key) == "string" and key or val
      table.insert(servers_to_install, name)

      local lsp_cfg = vim.lsp.config[name] or {}
      if cfg.filetypes then
        lsp_cfg.filetypes = cfg.filetypes
      end
      if type(val) == "table" and val.settings then
        lsp_cfg.settings = val.settings
      end

      vim.lsp.config(name, lsp_cfg)
      vim.lsp.enable(name)
    end
  end

  if cfg.tools then
    for _, tool in ipairs(cfg.tools) do
      table.insert(tools_to_install, tool)
    end
  end

  if cfg.formatters then
    formatters_by_ft[ft] = {}
    for k, v in pairs(cfg.formatters) do
      local n = type(k) == "string" and k or v
      table.insert(formatters_by_ft[ft], n)
      if type(k) == "string" then
        custom_formatter_configs[k] = v
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
require("mason-lspconfig").setup({ ensure_installed = servers_to_install })
require("mason-tool-installer").setup({ ensure_installed = tools_to_install })

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
    vim.keymap.set(
      "n",
      "<leader>cs",
      "<cmd> lua MiniExtra.pickers.lsp({ scope = 'document_symbol' })<cr>",
      { desc = "Symbols" }
    )
    vim.keymap.set(
      "n",
      "<leader>cl",
      "<cmd> lua MiniExtra.pickers.lsp({ scope = 'definition' })<cr>",
      { desc = "Definition" }
    )
    vim.keymap.set(
      "n",
      "<leader>cr",
      "<cmd> lua MiniExtra.pickers.lsp({ scope = 'references' })<cr>",
      { buffer = args.buf, desc = "References" }
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
