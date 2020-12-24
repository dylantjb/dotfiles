" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " Better syntax support
    Plug 'morhetz/gruvbox'
    Plug 'kaicataldo/material.vim', { 'branch': 'main' }
    " Shows recently edited files
    Plug 'mhinz/vim-startify'
    " Shows context in code
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Browse your system
    Plug 'kevinhwang91/rnvimr'
    " For navigation in file
    Plug 'justinmk/vim-sneak'
    " Syntax Coloring
    Plug 'sjl/badwolf'

call plug#end()
