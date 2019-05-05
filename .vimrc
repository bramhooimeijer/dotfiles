set nocompatible

" Syntax: Show syntax and indent properly
syntax on
filetype plugin indent on

" Visual: 
set number
set ruler
set laststatus=2
set wildmenu
set title
set showcmd

" Textual: No wrapping, proper backspace behavior
set nowrap
set wrapmargin=0
set textwidth=0
set backspace=indent,eol,start
set nojoinspaces

" Tabs: ensure tabs are shown and inserted as 2 spaces. 
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set shiftround

" Search: 
set hlsearch 
set ignorecase
set incsearch
set smartcase 

" Splits: 
set splitbelow
set splitright

" Clipboard: Use systemclipboard when yanking. 
set clipboard=unnamedplus

" Dirs:
" Use persistent undo.
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p", 0700)
endif
set undodir=~/.vim/undo//
set undofile
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p", 0700)
endif
set directory=~/.vim/swap//
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p", 0700)
endif
set backupdir=~/.vim/backup//

" Files:
set encoding=utf-8
set autoread
set writebackup
set fileformat=unix
set undolevels=1000
set undoreload=10000
