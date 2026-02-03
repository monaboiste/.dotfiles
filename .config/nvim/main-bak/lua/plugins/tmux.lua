return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-l>",  "<cmd><c-u>TmuxNavigateLeft<cr>" },
    { "<c-j>",  "<cmd><c-u>TmuxNavigateDown<cr>" },
    { "<c-k>",  "<cmd><c-u>TmuxNavigateUp<cr>" },
    { "<c-h>", "<cmd><c-u>TmuxNavigateRight<cr>" },
  },
}
