-- Panes navigation to better fit tmux convention
vim.keymap.set("n", '<leader>w"', ":split<cr>", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>w%", ":vsplit<cr>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>wq", ":quit<cr>", { desc = "Close" })
vim.keymap.set("n", "<leader>t", ":tabnew<cr>", { desc = "New Tab" })

-- Tmux
vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" })
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<cr>")
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<cr>")
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<cr>")
