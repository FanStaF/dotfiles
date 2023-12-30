require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  -- ensure_installed = {
  --   'php', 'lua', 'html', 'sql', 'javascript', 'bash'
  --   },
    
    highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['if'] = '@function.inner',
        ['af'] = '@function.outer',
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
      },
    }
  }
})
