return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- GitHub Dark theme for lualine
        local colors = require('colors.github-dark').colors
        local github_dark = {
            normal = {
                a = { fg = colors.bg, bg = colors.blue, gui = 'bold' },
                b = { fg = colors.fg, bg = colors.bg_highlight },
                c = { fg = colors.fg_muted, bg = colors.bg },
            },
            insert = {
                a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
            },
            visual = {
                a = { fg = colors.bg, bg = colors.purple, gui = 'bold' },
            },
            replace = {
                a = { fg = colors.bg, bg = colors.red, gui = 'bold' },
            },
            command = {
                a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
            },
            inactive = {
                a = { fg = colors.fg_muted, bg = colors.bg_highlight },
                b = { fg = colors.fg_muted, bg = colors.bg_highlight },
                c = { fg = colors.fg_muted, bg = colors.bg },
            },
        }

        require('lualine').setup({
            options = {
                theme = github_dark
            }
        })
    end
}
