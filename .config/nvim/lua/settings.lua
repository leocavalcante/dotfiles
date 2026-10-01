vim.g.have_nerd_font = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'

-- A yank in one nvim is invisible to the nvim the next pane starts.
-- The tmux paste buffer is shared by every pane on this server.
if vim.env.TMUX ~= nil and vim.fn.executable('tmux') == 1 then
  vim.g.clipboard = {
    name = 'tmux-buffer',
    copy = {
      ['+'] = { 'tmux', 'load-buffer', '-' },
      ['*'] = { 'tmux', 'load-buffer', '-' },
    },
    -- A server with no buffers yet exits 1, which nvim would show as a paste error.
    paste = {
      ['+'] = { 'sh', '-c', 'tmux save-buffer - 2>/dev/null' },
      ['*'] = { 'sh', '-c', 'tmux save-buffer - 2>/dev/null' },
    },
    -- With the cache on, nvim answers from its own last yank and skips tmux.
    cache_enabled = 0,
  }
end
vim.opt.cursorline = true
vim.opt.expandtab = true
-- vim.opt.guicursor = ""
vim.opt.ignorecase = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true

-- Load Gruvbox Dark colorscheme
require("colors.gruvbox-dark").setup()

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldenable = true
    vim.opt_local.foldlevel = 99
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt.tabstop = 4   -- Set tabstop to 4 spaces for Go files
    vim.opt.shiftwidth = 4 -- Set shiftwidth to 4 spaces for Go files
    vim.opt.expandtab = true -- Ensure tabs are expanded to spaces
    -- Add any other vim.opt settings specific to Go files here
  end,
})

