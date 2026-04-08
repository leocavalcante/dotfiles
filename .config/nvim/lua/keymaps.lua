vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' });
vim.keymap.set('n', '<leader><C-l>', ':vsplit<CR>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>bd', ':bp|bd #<CR>', { silent = true, desc = 'Delete current buffer and go to previous' })

vim.keymap.set('v', '<leader>64d', function()
  vim.cmd('normal! "xy')
  local decoded = vim.fn.system('base64 -d', vim.fn.getreg('x')):gsub('\n$', '')
  vim.fn.setreg('x', decoded)
  vim.cmd('normal! gv"xp')
end, { desc = 'Decode base64 selection' })

vim.keymap.set('v', '<leader>64e', function()
  vim.cmd('normal! "xy')
  local encoded = vim.fn.system('base64', vim.fn.getreg('x')):gsub('\n$', '')
  vim.fn.setreg('x', encoded)
  vim.cmd('normal! gv"xp')
end, { desc = 'Encode base64 selection' })

