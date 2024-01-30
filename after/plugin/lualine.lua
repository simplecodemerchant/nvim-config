local theme = require('lualine.themes.iceberg_dark')
require('lualine').setup({
    options = { theme = theme },
    extensions = {
        'oil',
        'neo-tree',
        'trouble'
    },
})
