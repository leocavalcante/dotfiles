return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use 'nvim-treesitter/nvim-treesitter'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use {'neoclide/coc.nvim', branch = 'release'}
  use 'marko-cerovac/material.nvim'
  use 'jghauser/mkdir.nvim'
  use 'f-person/git-blame.nvim'
  use 'gpanders/editorconfig.nvim'
  use 'aserowy/tmux.nvim'
  use 'wakatime/vim-wakatime'
  use 'ziglang/zig.vim'
end)
