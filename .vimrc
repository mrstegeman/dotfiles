" must be first
set nocompatible

" general settings
filetype plugin indent on
set autoindent
set background=dark
set backspace=indent,eol,start
set cino=(0
set completeopt=longest,menuone
set eol
set expandtab
set ff=unix
set fixeol
set formatoptions=l
set ignorecase
set incsearch
set lbr
set modeline
set modelines=1
set mouse=a
set nohlsearch
set number
set ruler
set scrolloff=5
set shell=/bin/bash
set shiftwidth=4
set showmatch
set showmode
set smartindent
set softtabstop=4
set spelllang=en_us
set tabstop=4
set termguicolors
set title
set wildmenu
set wildmode=longest,list
syntax on

" vimdiff/non-vimdiff specific things
if &diff
    windo set wrap
else
    set cc=100
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
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'keith/swift.vim'
Plug 'pangloss/vim-javascript'
Plug 'crusoexia/vim-javascript-lib'
Plug 'mrstegeman/detectindent'
Plug 'crusoexia/vim-monokai'
Plug 'leafgarland/typescript-vim'
Plug 'Vimjas/vim-python-pep8-indent'

" Initialize plugin system
call plug#end()

colorscheme monokai

" settings for vim-detectindent
let g:detectindent_preferred_expandtab=1
let g:detectindent_preferred_indent=4
autocmd BufReadPost * :DetectIndent 

" settings for airline
let g:airline_theme='molokai'
let g:airline#extensions#ale#enabled = 1

" settings for ALE

" enable italicized comments
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
highlight Comment cterm=italic
