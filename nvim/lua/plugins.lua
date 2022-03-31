return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use 'ms-jpq/coq_nvim'
  use 'ms-jpq/coq.artifacts'
  use 'nvim-treesitter/nvim-treesitter'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use 'marko-cerovac/material.nvim'
  use 'jghauser/mkdir.nvim'
  use 'f-person/git-blame.nvim'
  use 'gpanders/editorconfig.nvim'
  use 'aserowy/tmux.nvim'
end)
