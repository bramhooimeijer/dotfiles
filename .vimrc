if &compatible
  set nocompatible
endif

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
" Move temporary files to a secure location to protect against CVE-2017-1000382
if exists('$XDG_CACHE_HOME')
  let &g:directory=$XDG_CACHE_HOME
else
  let &g:directory=$HOME . '/.cache'
endif
let &g:undodir=&g:directory . '/vim/undo//'
let &g:backupdir=&g:directory . '/vim/backup//'
" Create directories if they doesn't exist
if ! isdirectory(expand(&g:directory))
  silent! call mkdir(expand(&g:directory), 'p', 0700)
endif
if ! isdirectory(expand(&g:backupdir))
  silent! call mkdir(expand(&g:backupdir), 'p', 0700)
endif
if ! isdirectory(expand(&g:undodir))
  silent! call mkdir(expand(&g:undodir), 'p', 0700)
endif
set undofile

" Files:
set encoding=utf-8
set autoread
set writebackup
set fileformat=unix
set undolevels=1000
set undoreload=10000

