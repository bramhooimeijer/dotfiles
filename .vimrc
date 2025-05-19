if &compatible
  set nocompatible
endif
if !has('gui_running')
  set t_Co=256
endif

if has('win32')||has('win64')
  language en                 " sets the language of the messages / ui (vim)
  let $HOME="C:/Localdata/"
  set viminfo+=nC:/Localdata/.vim
endif

" gVIM specific
if has('gui_running')
  set langmenu=en_US.UTF-8    " sets the language of the menu (gvim)
  set guioptions-=m  "menu bar
  set guioptions-=T  "toolbar
  set guioptions-=r  "scrollbar on the right
  set guioptions-=L  "scrollbar on the left (upon window split)
  set hidden
  set guifont=Noto_Mono_for_Powerline:h10:cANSI:qDRAFT
endif

""""""""""""
" Options: "
""""""""""""

" Syntax: Show syntax and indent properly
filetype plugin indent on
syntax on
set modeline

" Visual:
set number relativenumber
augroup numbertoggle
  au!
  au BufEnter,FocusGained,InsertLeave * set relativenumber
  au BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set laststatus=2
set title
set noshowcmd
set noshowmode
set visualbell

" Completion:
set wildmode=longest:full,full
set wildmenu
set completeopt+=menuone,noselect,noinsert
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

" Format: Soft wrapping, proper backspace behavior
set linebreak
set backspace=indent,eol,start
set nojoinspaces

" Tabs:
set tabstop=8 softtabstop=2 shiftwidth=2 expandtab
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
if has('win32') || has('win64')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

" Dirs:
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

" Files:
set encoding=utf-8
set autoread
set writebackup
set fileformat=unix

set list
set listchars=tab:├─,trail:·

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
" nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:noh<CR>  " overwritten by ALE
let maplocalleader = "-"
let mapleader = "\<Space>"
cmap w!! w !sudo tee > /dev/null %
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>i gi
nnoremap <leader>r :%s/\<<C-r><C-w>\>/

"""""""""""""""""""
" File Specifics: "
"""""""""""""""""""

augroup fileOptions
 au!
 au BufNewFile,BufRead *.tikz setlocal syntax=tex
 au BufNewFile,BufRead *.h let c_syntax_for_h = 1
 au Syntax c,cpp call SetCOptions()
 au Syntax python call SetPythonOptions()
 au Syntax rust call SetRustOptions()
 au Syntax sh setlocal sts=0 sw=8 noexpandtab
 au Syntax vim setlocal commentstring=\"\ %s
augroup END

function! SetPythonOptions()
  setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  setlocal colorcolumn=80
  setlocal autoindent
  normal zR
endfunction

function! SetCOptions()
  setlocal softtabstop=8 shiftwidth=8 noexpandtab
  setlocal foldmethod=syntax
  normal zR
  setlocal colorcolumn=80
  inoremap <buffer> ;; ->
endfunction

function! SetRustOptions()
  setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  inoremap <buffer> ;; =>
endfunction

""""""""""""""""""""
" Plugin_settings: "
""""""""""""""""""""

" Vim_easy_align:
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Plugins:
call plug#begin('$HOME/.vim/plugged')
" Completion:
" Plug 'lifepillar/vim-mucomplete'
" Plug 'wellle/tmux-complete.vim'

" Appearance:
Plug 'junegunn/vim-easy-align'                                            " Improves = align using ga
Plug 'tpope/vim-commentary'                                               " Toggle comment using gc
Plug 'tpope/vim-surround'                                                 " Change/add surrounding ("[ etc
Plug 'ludovicchabant/vim-gutentags'

call plug#end()

" Colorscheme:
set termguicolors
colorscheme retrobox
