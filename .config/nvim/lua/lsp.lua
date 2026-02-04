local registry = {
  lua = {
    servers = { "lua_ls" },
    tools = { "stylua" },
  },
  shell = {
    servers = { "bashls" },
    tools = { "shellcheck", "shfmt" },
  },
  sql = {
    servers = { "sqls" },
    tools = { "sqlfluff" },
  },
}

local servers = {}
local tools = {}

for _, lang in pairs(registry) do
  if lang.servers then
    for _, s in ipairs(lang.servers) do table.insert(servers, s) end
  end
  if lang.tools then
    for _, t in ipairs(lang.tools) do table.insert(tools, t) end
  end
end

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = servers })
require("mason-tool-installer").setup({ ensure_installed = tools })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc ="Code action", buffer = args.buf })
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = args.buf })
      vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "Show", buffer = args.buf })
      vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Goto declaration", buffer = args.buf })
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Goto definition", buffer = args.buf })
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Goto implementation", buffer = args.buf })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "References", buffer = args.buf })
    end
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

