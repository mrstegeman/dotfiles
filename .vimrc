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

" settings for vim-detectindent
let g:detectindent_preferred_expandtab=1
let g:detectindent_preferred_indent=4
autocmd BufReadPost * :DetectIndent 

" maps
nnoremap <silent> ,b :TagbarToggle<CR>

" fixes for certain file types
autocmd FileType make set cc=0
