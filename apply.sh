#!/bin/env zsh

# zsh
rm ~/.zshrc
ln -s $(pwd)/zshrc.sh ~/.zshrc

# tmux
rm ~/.tmux.conf
ln -s $(pwd)/tmux.conf ~/.tmux.conf

# neovim
rm ~/.config/nvim/init.vim
ln -s $(pwd)/neovim.vim ~/.config/nvim/init.vim

