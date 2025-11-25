return {
  'rebelot/kanagawa.nvim',
  priority = 1000,
  name = 'kanagawa',
  config = function()
    require('kanagawa').setup {
      commentStyle = { italic = false },
    }
    vim.cmd.colorscheme 'kanagawa-wave'
  end,
}
