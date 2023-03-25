#!/bin/sh
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

echo 'set nu
syntax on
colorscheme ir_black' > ~/.vim_runtime/my_configs.vim
