return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "lua_ls", "vtsls", "eslint", "bashls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          local function opts(desc)
            return { desc = desc, buffer = args.buf }
          end

          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
          vim.keymap.set("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, opts("Format"))
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts("Rename"))
          vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts("Show"))
          vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts("Goto declaration"))
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts("Goto definition"))
          vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts("Goto implementation"))
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts("References"))
        end,
      })

      vim.diagnostic.config({
        -- Inline diagnostics
        virtual_text = true,
      })

      local servers = { "lua_ls", "vtsls", "eslint", "bashls" }
      for _, server in ipairs(servers) do
        local cfg = vim.lsp.config[server]
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
      end
    end,
  },
  -- Completions
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
        ["<tab>"] = { "accept", "fallback" },
        ["<C><leader>"] = { "show" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  -- Diagnostics
  {
    "folke/trouble.nvim",
    opts = {},
    keys = {
      { "<leader>cD", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    }
  }
}
