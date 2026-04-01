return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local colors = require('colors.gruvbox-dark').colors
        local gruvbox_dark = {
            normal = {
                a = { fg = colors.bg, bg = colors.blue, gui = 'bold' },
                b = { fg = colors.fg, bg = colors.bg_highlight },
                c = { fg = colors.fg_muted, bg = colors.bg },
            },
            insert = {
                a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
                b = { fg = colors.fg, bg = colors.bg_highlight },
                c = { fg = colors.fg_muted, bg = colors.bg },
            },
            visual = {
                a = { fg = colors.bg, bg = colors.purple, gui = 'bold' },
                b = { fg = colors.fg, bg = colors.bg_highlight },
                c = { fg = colors.fg_muted, bg = colors.bg },
            },
            replace = {
                a = { fg = colors.bg, bg = colors.red, gui = 'bold' },
                b = { fg = colors.fg, bg = colors.bg_highlight },
                c = { fg = colors.fg_muted, bg = colors.bg },
            },
            command = {
                a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
                b = { fg = colors.fg, bg = colors.bg_highlight },
                c = { fg = colors.fg_muted, bg = colors.bg },
            },
            terminal = {
                a = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
                b = { fg = colors.fg, bg = colors.bg_highlight },
                c = { fg = colors.fg_muted, bg = colors.bg },
            },
            inactive = {
                a = { fg = colors.fg_muted, bg = colors.bg_highlight },
                b = { fg = colors.fg_muted, bg = colors.bg_highlight },
                c = { fg = colors.fg_subtle, bg = colors.bg },
            },
        }

        require('lualine').setup({
            options = {
                theme = gruvbox_dark,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            }
        })
    end
}
