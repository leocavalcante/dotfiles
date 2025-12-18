vim.g.have_nerd_font = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
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

-- Load GitHub Dark colorscheme
require("colors.github-dark").setup()

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt.tabstop = 4   -- Set tabstop to 4 spaces for Go files
    vim.opt.shiftwidth = 4 -- Set shiftwidth to 4 spaces for Go files
    vim.opt.expandtab = true -- Ensure tabs are expanded to spaces
    -- Add any other vim.opt settings specific to Go files here
  end,
})

