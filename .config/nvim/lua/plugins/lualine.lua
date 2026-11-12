return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- Lualine's timers queue a vim.schedule() callback on every tick. While
        -- Neovim is blocked (for example at a "Press ENTER" prompt), those
        -- callbacks cannot run, so the 16 ms refresh checker grows memory without
        -- bound (one idle session reached 6+ GB). Keep at most one queued
        -- callback per timer. Remove this once lualine coalesces upstream.
        local lualine_utils = require('lualine.utils.utils')
        lualine_utils.timer_call = function(timer, augroup, fn, max_err, err_msg)
            local err_cnt, ret, queued = 0, nil, false
            max_err = max_err or 3
            local function run(...)
                queued = false
                if err_cnt > max_err then
                    vim.uv.timer_stop(timer)
                    if augroup then
                        vim.cmd(string.format([[augroup %s | exe "autocmd!" | augroup END]], augroup))
                    end
                    error(err_msg .. ':\n' .. tostring(ret))
                end
                local ok
                ok, ret = pcall(fn, ...)
                err_cnt = ok and 0 or err_cnt + 1
                return ret
            end
            return function(...)
                if queued then return end
                queued = true
                local args = vim.F.pack_len(...)
                vim.schedule(function() run(vim.F.unpack_len(args)) end)
            end
        end

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
