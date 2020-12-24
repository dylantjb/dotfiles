" Source of plugins
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/plug-config/rnvimr.vim

" Set clipboard globally
set clipboard=unnamedplus

" Mouse works on all modes
set mouse=a

" Enables line numbers
set number
set relativenumber

" Sets encoding
set encoding=utf-8

" Sets terminal colors
set termguicolors

" Maps leader to space
let mapleader = " "

" Fixes tab spacing
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Selects the color scheme
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

" Removes trailing spaces after saving
autocmd BufWritePre * %s/\s\+$//e

" Enable Disable auto comment on file
map <leader>c :setlocal formatoptions-=cro<CR>
map <leader>C :setlocal formatoption=cro<CR>

" Enable spell check on file
map <leader>s :setlocal spell! spellleng=en_gb<CR>

" Enable Disable auto indent
map <leader>i :setlocal autoindent<CR>
map <leader>I :setlocal noautoindent<CR>

" Compile and open output
map <leader>G :w! \| !comp <c-r>%<CR><CR>
map <leader>o :!opout <c-r>%<CR><CR>

" Fix splitting
set splitbelow splitright
