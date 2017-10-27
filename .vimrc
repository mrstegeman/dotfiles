" must be first
set nocompatible

" general settings
colorscheme desert
filetype plugin indent on
set autoindent
set backspace=indent,eol,start
set cino=(0
set completeopt=longest,menuone
set expandtab
set ff=unix
set formatoptions=l
set ignorecase
set incsearch
set lbr
set modeline
set mouse=a
set ruler
set scrolloff=5
set shell=/bin/bash
set shiftwidth=4
set showmatch
set showmode
set smartindent
set softtabstop=4
set spelllang=en_us
set t_Co=256
set tabstop=4
set title
set wildmenu
set wildmode=longest,list
syntax on

" vimdiff/non-vimdiff specific things
if &diff
    windo set wrap
else
    set cc=80
endif

" fixes for certain file types
autocmd FileType make set cc=0

" auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Plugins...
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'

" Initialize plugin system
call plug#end()

" settings for vim-detectindent
let g:detectindent_preferred_expandtab=1
let g:detectindent_preferred_indent=4
autocmd BufReadPost * :DetectIndent 

" settings for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_rust_checkers = ['rustc']
