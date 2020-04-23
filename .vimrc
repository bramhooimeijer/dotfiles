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
hi Search ctermbg=LightGray
hi Search ctermfg=Red

" Visual:
set number
set ruler
set laststatus=2
set title
set noshowcmd
set noshowmode

" Completion:
set wildmode=longest:full,full
set wildmenu
set completeopt+=longest,menuone,noselect,noinsert
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

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
  let &g:directory=$XDG_CACHE_HOME . '/vim/swap//'
else
  let &g:directory=$HOME . '/.cache/vim/swap//'
endif
let &g:undodir=&g:directory . '/../../vim/undo//'
let &g:backupdir=&g:directory . '/../../vim/backup//'
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

" KeyBinds: F5 removes trailing spaces
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:noh<CR>
let maplocalleader = "-"
let mapleader = "\<Space>"
cmap w!! w !sudo tee > /dev/null %
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>r :%s/\<<C-r><C-w>\>/

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
let g:tex_fast = "cmMprsSvV"

" Mucomplete:
" add neosnippets to mucomplete chain
let g:mucomplete#chains = {
      \ 'vim'     : ['path', 'cmd', 'keyn'],
      \ 'default' : ['path', 'omni', 'nsnp', 'keyn',  'dict', 'uspl']
      \}

" Neosnippet:
imap <C-u>     <Plug>(neosnippet_expand_or_jump)
smap <C-u>     <Plug>(neosnippet_expand_or_jump)
xmap <C-u>     <Plug>(neosnippet_expand_target)
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='$HOME/.vim/plugged/vim-snippets/snippets,$CLOUD_HOME/Syncs/Vim/snippets'

" Plugins:
call plug#begin('$HOME/.vim/plugged')
" Completion:
Plug 'lifepillar/vim-mucomplete'
Plug 'wellle/tmux-complete.vim'
" Snippets:
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'shougo/neosnippet.vim'
Plug 'shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

Plug 'itchyny/lightline.vim'            " Theme
Plug 'christoomey/vim-tmux-navigator/'  " Allows pane change using TMUX
Plug 'junegunn/vim-easy-align'          " Improves = align using ga=
Plug 'tpope/vim-commentary'             " Toggle comment using gc
Plug 'scrooloose/nerdtree'              " Opens filetree using C-n in normal mode
Plug 'vhda/verilog_systemverilog.vim'   " Extensions for coding in .sv
Plug 'lervag/vimtex'                    " Extensions for markup in .tex
call plug#end()
