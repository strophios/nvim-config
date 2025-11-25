return {
  'rose-pine/neovim',
  priority = 1000,
  name = 'rose-pine',
  config = function()
    require('rose-pine').setup {
      styles = { italic = false }, -- Not sure whether I want this or not. Want non-italic comments, but this maybe turns it off everywhere.
    }
    vim.cmd.colorscheme 'rose-pine'
  end,
}
