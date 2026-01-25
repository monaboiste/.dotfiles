return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "lua_ls", "eslint", "ts_ls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          -- Enable autocomplition triggered by <ctrl+x><ctrl+o>
          vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
            desc = "Code action",
          })
          vim.keymap.set({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, {
            desc = "Run codelens",
          })
          vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {
            desc = "Show",
          })
          vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {
            desc = "Goto declaration",
          })
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {
            desc = "Goto definition ",
          })
          vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {
            desc = "Goto implementation",
          })
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {
            desc = "References",
          })
          vim.keymap.set("n", "<leader>cf", function()
            vim.lsp.buf.format({ async = true, })
          end, {
            desc = "Format",
          })
          vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, {
            desc = "Diagnostics",
          })
        end,
      })

      vim.diagnostic.config({
        virtual_text = true,
      })

      local servers = { "lua_ls", "eslint", "ts_ls" }
      for _, server in ipairs(servers) do
        local cfg = vim.lsp.config[server]
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
      end
    end,
  },
}
