local M = {}

M.blink = {
  preset = "default",
  ["<tab>"] = { "accept", "fallback" },
  ["<C><Space>"] = { "show" },
}

M.clue_triggers = {
  { mode = { "n", "x" }, keys = "<leader>" },
  { mode = "n", keys = "[" },
  { mode = "n", keys = "]" },
  { mode = "n", keys = "g" },
  { mode = "n", keys = "z" },
  { mode = "n", keys = "'" },
  { mode = "n", keys = "`" },
  { mode = { "n", "x" }, keys = '"' },
  { mode = "i", keys = "<C-x>" },
  { mode = "n", keys = "<C-w>" },
}

function M.clues(miniclue)
  return {
    { mode = "n", keys = "<leader>c", desc = "+Code (LSP)" },
    { mode = "n", keys = "<leader>f", desc = "+Find" },
    { mode = "n", keys = "<leader>x", desc = "+Diagnostics" },
    { mode = "n", keys = "<leader>t", desc = "+Tabs" },
    { mode = "n", keys = "<leader>g", desc = "+Goto" },
    { mode = "n", keys = "<leader>h", desc = "+Git hunks" },

    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers({ show_contents = true }),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  }
end

function M.setup()
  vim.keymap.set("x", "p", [['pgv"'.v:register.'y']], {
    expr = true,
    desc = "Paste without changing the register",
  })
  vim.keymap.set(
    "n",
    "<Esc>",
    "<cmd>nohlsearch<cr>",
    { desc = "Clear search highlighting" }
  )
  vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
  vim.keymap.set(
    "n",
    "<C-c>",
    'V"+y',
    { desc = "Copy line to system clipboard" }
  )
  vim.keymap.set("n", "<C-d>", "5j", { desc = "Jump down by 5 lines" })
  vim.keymap.set("n", "<C-e>", "5k", { desc = "Jump up by 5 lines" })

  vim.keymap.set(
    "n",
    '<leader>t"',
    ":split<cr>",
    { desc = "Split horizontally" }
  )
  vim.keymap.set(
    "n",
    "<leader>t%",
    ":vsplit<cr>",
    { desc = "Split vertically" }
  )
  vim.keymap.set("n", "<leader>tq", ":quit<cr>", { desc = "Close" })
  vim.keymap.set("n", "<leader>tt", ":tabnew<cr>", { desc = "New Tab" })

  vim.keymap.set("n", "<leader>hb", function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "gitsigns-blame" then
        vim.api.nvim_win_close(win, true)
        return
      end
    end
    require("gitsigns").blame()
  end, { desc = "Toggle Git blame" })

  vim.keymap.set({ "n", "x" }, "<leader>s", function()
    if vim.fn.mode():match("[vV\22]") then
      vim.cmd("'<,'>sort")
    else
      vim.cmd("%sort")
    end
  end, { desc = "Sort selection or file" })

  vim.keymap.set("n", "<leader><leader>", function()
    require("mini.pick").builtin.cli({
      command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
    })
  end, { desc = "Find Files" })
  vim.keymap.set("n", "<leader>fb", function()
    require("mini.pick").builtin.buffers()
  end, { desc = "Find Buffers" })
  vim.keymap.set("n", "<leader>fv", function()
    require("mini.extra").pickers.visit_paths({ cwd = "" })
  end, { desc = "Find Visited Files Everywhere" })
  vim.keymap.set("n", "<leader>fg", function()
    require("mini.pick").builtin.grep_live()
  end, { desc = "Live Grep" })
  vim.keymap.set("n", "<leader>fc", function()
    require("mini.extra").pickers.history({ scope = ":" })
  end, { desc = "Find Command" })
  vim.keymap.set("n", "<leader>fr", function()
    require("mini.extra").pickers.registers()
  end, { desc = "Registers" })
  vim.keymap.set("n", "<leader>xx", function()
    require("mini.extra").pickers.diagnostic()
  end, { desc = "Diagnostics" })
  vim.keymap.set("n", "<leader>xX", function()
    require("mini.extra").pickers.diagnostic({ scope = "current" })
  end, { desc = "Buffer Diagnostics" })

  vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    })
  end, { desc = "Format" })

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
      vim.keymap.set("n", "<leader>cs", function()
        require("mini.extra").pickers.lsp({ scope = "document_symbol" })
      end, { desc = "Symbols", buffer = args.buf })
      vim.keymap.set("n", "<leader>cl", function()
        require("mini.extra").pickers.lsp({ scope = "definition" })
      end, { desc = "Definition", buffer = args.buf })
      vim.keymap.set("n", "<leader>cr", function()
        require("mini.extra").pickers.lsp({ scope = "references" })
      end, { desc = "References", buffer = args.buf })
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
end

function M.setup_multicursor(mc)
  vim.keymap.set({ "n", "x" }, "<M-S-Up>", function()
    mc.lineAddCursor(-1)
  end, { desc = "Add cursor up" })
  vim.keymap.set({ "n", "x" }, "<M-S-Down>", function()
    mc.lineAddCursor(1)
  end, { desc = "Add cursor down" })
  vim.keymap.set({ "n", "x" }, "<C-S-Up>", function()
    mc.lineSkipCursor(-1)
  end, { desc = "Skip cursor up" })
  vim.keymap.set({ "n", "x" }, "<C-S-Down>", function()
    mc.lineSkipCursor(1)
  end, { desc = "Skip cursor down" })
  vim.keymap.set({ "n", "x" }, "<C-g>", function()
    mc.matchAddCursor(1)
  end, { desc = "Add cursor by matching word/selection" })
  vim.keymap.set({ "n", "x" }, "<C-M-g>", function()
    mc.matchSkipCursor(-1)
  end, { desc = "Remove cursor by matching word/selection" })
  vim.keymap.set("n", "<C-LeftMouse>", mc.handleMouse, { desc = "Add cursors" })
  vim.keymap.set(
    "n",
    "<C-LeftDrag>",
    mc.handleMouseDrag,
    { desc = "Add cursors" }
  )
  vim.keymap.set(
    "n",
    "<C-LeftRelease>",
    mc.handleMouseRelease,
    { desc = "Remove cursors" }
  )
  vim.keymap.set(
    "n",
    "<leader>cv",
    mc.restoreCursors,
    { desc = "Restore cleared cursors" }
  )

  mc.addKeymapLayer(function(layerSet)
    layerSet("n", "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      else
        mc.clearCursors()
      end
    end)
  end)
end

return M
