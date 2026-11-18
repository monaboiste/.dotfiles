vim.pack.add({
  {
    src = "https://github.com/delphinus/md-render.nvim",
    version = vim.version.range("3"),
  },
})

local chrome = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if not vim.env.PUPPETEER_EXECUTABLE_PATH and vim.fn.executable(chrome) == 1 then
  vim.env.PUPPETEER_EXECUTABLE_PATH = chrome
end

local preview = require("md-render.preview")
local build_content = preview.build_content
local expanded = setmetatable({}, {
  __index = function()
    return true
  end,
})

preview.build_content = function(lines, opts)
  opts = vim.tbl_extend("force", {}, opts or {}, {
    expand_state = expanded,
  })
  local content = build_content(lines, opts)
  local width = opts.max_width or vim.g.md_render_max_width

  for _, highlight in ipairs(content.highlights) do
    local index = highlight.line + 1
    local line = content.lines[index]
    local prefix = line:match("^(.-)─")
    if
      prefix
      and line:gsub("─", "") == prefix
      and vim.api.nvim_strwidth(line) > width
    then
      for _, group in ipairs(highlight.groups) do
        if
          group.hl == "FloatBorder"
          and group.col == 0
          and group.end_col == #line
        then
          local length = math.max(0, width - vim.api.nvim_strwidth(prefix))
          line = prefix .. string.rep("─", length)
          content.lines[index] = line
          group.end_col = #line
        end
      end
    end
  end

  return content
end

local group = vim.api.nvim_create_augroup("markdown.preview", { clear = true })

vim.g.md_render_max_width = vim.o.columns
vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
  group = group,
  callback = function()
    vim.g.md_render_max_width = vim.o.columns
  end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = group,
  callback = function(args)
    if vim.b[args.buf].md_render then
      local source_wrap = vim.w.markdown_source_wrap
      if source_wrap ~= nil then
        vim.wo.wrap = source_wrap
      end
    else
      vim.w.markdown_source_wrap = vim.wo.wrap
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = vim.schedule_wrap(function(args)
    if
      vim.api.nvim_get_current_buf() ~= args.buf
      or not vim.b[args.buf].md_render
    then
      return
    end

    vim.wo.wrap = true
    require("mini.clue").enable_buf_triggers(args.buf)

    local state = vim.w.md_render_state
    if state and state.mode == "render" and state.render_buf == args.buf then
      vim.keymap.set("n", "q", "<cmd>MdRender toggle<cr>", {
        buffer = args.buf,
        desc = "Return to Markdown source",
      })
    end
  end),
})
