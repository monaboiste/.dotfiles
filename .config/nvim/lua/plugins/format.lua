return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        sql = { "sql_formatter" },
        plsql = { "sql_formatter" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
}
