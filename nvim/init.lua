require('plugins')

require'nvim-tree'.setup {}
vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>:NvimTreeToggle<CR>', { noremap=true, silent=true })

require('telescope').setup {}
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap=true, silent=true })

require('tmux').setup {}

vim.o.mouse = 'a'
vim.g.gitblame_enabled = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.textwidth = 79
vim.o.formatoptions = 'qrn1'
vim.o.incsearch = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

require('github-theme').setup({
    theme_style = 'light'
})
