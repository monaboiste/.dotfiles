return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      color_overrides = {
        all = {
          base = "#23232b"
        }
      }
    }
  }, 
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = 
    {
      'nvim-lua/plenary.nvim', 
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      }
    }
  }
}
