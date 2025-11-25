return {
  {
    'maskudo/devdocs.nvim',
    lazy = false,
    dependencies = {
      'folke/snacks.nvim',
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        picker = { enabled = true },
      },
    },
    cmd = { 'DevDocs' },
    keys = {
      {
        '<leader>ho',
        mode = 'n',
        '<cmd>DevDocs get<cr>',
        desc = 'Get Devdocs',
      },
      {
        '<leader>hi',
        mode = 'n',
        '<cmd>DevDocs install<cr>',
        desc = 'Install Devdocs',
      },
      {
        '<leader>hv',
        mode = 'n',
        function()
          local devdocs = require 'devdocs'
          local installedDocs = devdocs.GetInstalledDocs()
          vim.ui.select(installedDocs, {}, function(selected)
            if not selected then
              return
            end
            local docDir = devdocs.GetDocDir(selected)
            -- prettify the filename as you wish
            Snacks.picker.files { cwd = docDir }
          end)
        end,
        desc = 'Get Devdocs',
      },
      {
        '<leader>hd',
        mode = 'n',
        '<cmd>DevDocs delete<cr>',
        desc = 'Delete Devdoc',
      },
    },
    opts = {
      ensure_installed = {
        'bash',
        'duckdb',
        'git',
        'jekyll~4',
        -- 'jinja~3.1', -- Currently throws an error when attempting to download. It appears this may be a genuine problem with the docs in devdocs.io itself
        'latex',
        'numpy~2.2',
        'nushell',
        'pandas~2',
        -- 'postgresql~18', -- Currently throws an error when attempting to download. This appears to be a genuine problem with the docs in devdocs.io itself.
        'python~3.14',
        'pytorch~2.7',
        'r',
        'ruby~3.4',
        'sqlite',
        'tensorflow',
        'zsh',
        'go',
        'rust',
        -- some docs such as lua require version number along with the language name
        -- check `DevDocs install` to view the actual names of the docs
        'lua~5.1',
        -- "openjdk~21"
      },
    },
  },
}
