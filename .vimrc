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
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
Plug 'keith/swift.vim'
Plug 'pangloss/vim-javascript'
Plug 'crusoexia/vim-javascript-lib'
Plug 'mrstegeman/detectindent'
Plug 'cespare/vim-toml'
Plug 'crusoexia/vim-monokai'
Plug 'leafgarland/typescript-vim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'projectfluent/fluent.vim'

" Initialize plugin system
call plug#end()

colorscheme monokai

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
let g:syntastic_typescript_checkers = ['eslint']
let g:syntastic_python_checkers = ['flake8', 'mypy', 'pydocstyle', 'python']
let g:syntastic_rust_checkers = ['cargo']
let g:syntastic_swift_checkers = ['swiftlint']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_flake8_exec = 'python3 -m flake8'
let g:syntastic_html_tidy_args = '--custom-tags blocklevel'

" enable italicized comments
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
highlight Comment cterm=italic
