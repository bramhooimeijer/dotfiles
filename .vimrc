if &compatible
  set nocompatible
endif
if !has('gui_running')
  set t_Co=256
endif

"""""""""""
" Options:"
"""""""""""

" Syntax: Show syntax and indent properly
filetype plugin indent on
syntax on

" Visual:
set number
set ruler
set laststatus=2
set cot+=longest
set wildmode=longest:full,full
set wildmenu
set title
set noshowcmd
set noshowmode

" Format: Soft wrapping, proper backspace behavior
set wrap
set linebreak
set wrapmargin=0
set textwidth=0
set backspace=indent,eol,start
set nojoinspaces

" Textwidth: Highlight column 79
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%79v', 100)

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
for s:c in ['a', 'A', '<Insert>', 'i', 'I', 'gI', 'gi', 'o', 'O']
    exe 'nnoremap ' . s:c . ' :nohlsearch<CR>' . s:c
endfor " clear highlight when inserting

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

" Spelling:
set spellfile=$CLOUD_HOME/Syncs/Vim/spell/en.utf-8.add

augroup spellfiles
  autocmd!
  " Per file spellfile
  autocmd BufNewFile,BufRead * let &l:spellfile .= ',' . expand('%:p:h') . '/.' .
  \ expand('%:t') . '.utf-8.add'

  " Per file type spellfile (FileType autocmd seems to fire before BufNewFile)
  autocmd BufNewFile,BufRead *.tex setlocal spellfile+=$CLOUD_HOME/Syncs/Vim/spell/tex.utf-8.add
augroup END

" Files:
set encoding=utf-8
set autoread
set writebackup
set fileformat=unix
set undolevels=1000
set undoreload=10000

""""""""""""""
" Functions: "
""""""""""""""

" PasteMode: Automatically enter pastemode when pasting
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" KeyBinds:
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:noh<CR>
let maplocalleader = "-"
let mapleader = "\<Space>"
cmap w!! w !sudo tee > /dev/null %
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

"""""""""""""""""""
" Plugin_settings:"
"""""""""""""""""""

" Vim_Tmux_Navigator:
nnoremap <silent> <C-a>h :TmuxNavigateLeft<cr>
nnoremap <silent> <C-a>j :TmuxNavigateDown<cr>
nnoremap <silent> <C-a>k :TmuxNavigateUp<cr>
nnoremap <silent> <C-a>l :TmuxNavigateRight<cr>
"nnoremap <silent> <C-a>\ :TmuxNavigatePrevious<cr>

" Vim_easy_align:
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" NerdTree:
nnoremap <C-n> :NERDTreeToggle<CR>

" VimTex:
let g:tex_flavor = 'latex'

" Neosnippet:
imap <C-u>     <Plug>(neosnippet_expand_or_jump)
smap <C-u>     <Plug>(neosnippet_expand_or_jump)
xmap <C-u>     <Plug>(neosnippet_expand_target)
"let g:neosnippet#enable_snipmate_compatibility = 1
"let g:neosnippet#snippets_directory='$HOME/.vim/plugged/vim-snippets/snippets'

" Plugins:
call plug#begin('$HOME/.vim/plugged')
Plug 'shougo/neosnippet.vim'
Plug 'shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'christoomey/vim-tmux-navigator/'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'vhda/verilog_systemverilog.vim'
Plug 'lervag/vimtex'
call plug#end()

