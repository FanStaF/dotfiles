local dashboard = require('dashboard')

dashboard.setup ({
    config = {
      header = {
        '⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀',
        '⡀⣶⣶⣶⣶⣶⣶⣶⣶⡆⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⣤⣶⣶⣦⣄⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⣶⣶⣶⣶⣶⣶⣶⣶⡆',
        '⡀⣿⣿⠉⠉⠉⠉⠉⠉⠁⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⢀⣿⡿⠉⠉⠻⣿⣆⡀⡀⡀⡀⢸⣿⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⣿⣿⠉⠉⠉⠉⠉⠉⠁',
        '⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⢸⣿⡀⡀⡀⡀⠿⠿⡀⡀⡀⡀⢸⣿⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀',
        '⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀⡀⡀⣠⣾⣿⣿⣿⣶⡀⡀⡀⣿⣿⢀⣾⣿⣿⣷⡄⡀⡀⠘⣿⣷⡀⡀⡀⡀⡀⡀⡀⠿⠿⢿⣿⠿⠿⠿⠇⡀⡀⡀⣠⣾⣿⣿⣿⣶⡀⡀⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀',
        '⡀⣿⣿⣶⣶⣶⣶⣶⡀⡀⡀⢠⣿⠏⡀⡀⡀⣿⡇⡀⡀⣿⣿⡟⡀⡀⡀⣿⣿⡀⡀⡀⠈⠻⣿⣶⣀⡀⡀⡀⡀⡀⡀⢸⣿⡀⡀⡀⡀⡀⡀⢠⣿⠏⡀⡀⡀⣿⡇⡀⡀⣿⣿⣶⣶⣶⣶⣶⡀⡀',
        '⡀⣿⣿⠉⠉⠉⠉⠉⡀⡀⡀⡀⡀⡀⣀⣴⣾⣿⡇⡀⡀⣿⣿⡀⡀⡀⡀⣿⣿⡀⡀⡀⡀⡀⡀⠛⣿⣿⣄⡀⡀⡀⡀⢸⣿⡀⡀⡀⡀⡀⡀⡀⡀⡀⣀⣴⣾⣿⡇⡀⡀⣿⣿⠉⠉⠉⠉⠉⡀⡀',
        '⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀⡀⢀⣾⣿⠛⠉⡀⣿⡇⡀⡀⣿⣿⡀⡀⡀⡀⣿⣿⡀⡀⣤⣤⡀⡀⡀⡀⢻⣿⡀⡀⡀⡀⢸⣿⡀⡀⡀⡀⡀⡀⢀⣾⣿⠛⠉⡀⣿⡇⡀⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀',
        '⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀⡀⣿⣿⡀⡀⡀⡀⣿⡇⡀⡀⣿⣿⡀⡀⡀⡀⣿⣿⡀⡀⣿⣿⡀⡀⡀⡀⣸⣿⡀⡀⡀⡀⢸⣿⡀⡀⡀⡀⡀⡀⣿⣿⡀⡀⡀⡀⣿⡇⡀⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀',
        '⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀⡀⠻⣿⣦⣤⣴⣿⣿⣇⡀⡀⣿⣿⡀⡀⡀⡀⣿⣿⡀⡀⠘⣿⣷⣤⣤⣾⣿⠏⡀⡀⡀⡀⢸⣿⣦⣤⣤⣶⡀⡀⠻⣿⣦⣤⣴⣿⣿⣇⡀⡀⣿⣿⡀⡀⡀⡀⡀⡀⡀',
        '⡀⠛⠛⡀⡀⡀⡀⡀⡀⡀⡀⡀⠈⠛⠛⠋⡀⠛⠛⡀⡀⠛⠛⡀⡀⡀⡀⠛⠛⡀⡀⡀⡀⠉⠛⠛⠋⡀⡀⡀⡀⡀⡀⡀⠉⠛⠛⠋⠁⡀⡀⡀⠈⠛⠛⠋⡀⠛⠛⡀⡀⠛⠛⡀⡀⡀⡀⡀⡀⡀',
        '⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀⡀',
        ''
      },
      center = {
        {
          icon = '  ',
          desc = 'New file                       ',
          action = 'enew',
        },
        {
          icon = '  ',
          shortcut = ', f',
          desc = 'Find file                 ',
          action = 'Telescope find_files',
        },
        {
          icon = '  ',
          shortcut = ', h',
          desc = 'Recent files              ',
          action = 'Telescope oldfiles',
        },
        {
          icon = '  ',
          shortcut = ', g',
          desc = 'Find Word                 ',
          action = 'Telescope live_grep',
        },
      },
      footer = {
        '',
        '-- FanStaF --',
        '',
      }
    }
  })


vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#6272a4' })
vim.api.nvim_set_hl(0, 'DashboardCenter', { fg = '#f8f8f2' })
vim.api.nvim_set_hl(0, 'DashboardShortcut', { fg = '#bd93f9' })
vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#6272a4' })

