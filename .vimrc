if &compatible
  set nocompatible
endif
if !has('gui_running')
  set t_Co=256
endif

" gVIM specific
if has('gui_running')
  set langmenu=en_US.UTF-8    " sets the language of the menu (gvim)
  language en                 " sets the language of the messages / ui (vim)
  set guioptions-=m  "menu bar
  set guioptions-=T  "toolbar
  set guioptions-=r  "scrollbar on the right
  set guioptions-=L  "scrollbar on the left (upon window split)
  if has('win32')||has('win64')
    let $HOME="C:/Localdata/"
    set viminfo+=nC:/Localdata/.vim
  endif
  set hidden
  set guifont=Noto_Mono_for_Powerline:h10:cANSI:qDRAFT
endif

if !exists('$CLOUD_HOME')
  let $CLOUD_HOME=$HOME
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
set wrap
set linebreak
set wrapmargin=0
set textwidth=0
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

" Spelling:
let spelldirectory=$CLOUD_HOME . '/Syncs/Vim/spell//'
if ! isdirectory(expand(spelldirectory))
  silent! call mkdir(expand(spelldirectory), 'p', 0700)
endif
execute "set spellfile=".spelldirectory . 'en.utf-8.add'

augroup spellfiles
  autocmd!
  " Per file spellfile
  autocmd BufNewFile,BufRead * let &l:spellfile .= ',' . expand('%:p:h') . '/.' .
  \ expand('%:t') . '.utf-8.add'

  " Per file type spellfile (FileType autocmd seems to fire before BufNewFile)
  autocmd BufNewFile,BufRead *.tex set spell | execute "setlocal spellfile+=" . spelldirectory . 'tex.utf-8.add'
augroup END


" Files:
set encoding=utf-8
set autoread
set writebackup
set fileformat=unix
set undolevels=1000
set undoreload=10000

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
nnoremap <leader>r :%s/\<<C-r><C-w>\>/

"""""""""""""""""""
" File Specifics: "
"""""""""""""""""""

augroup fileOptions
 au!
 au BufNewFile,BufRead *.py call SetPythonOptions()
 au BufNewFile,BufRead *.tikz setlocal syntax=tex
 au BufNewFile,BufRead *.beancount call SetBeancountOptions()
 au Syntax c,cpp call SetCOptions()
 au Syntax sh setlocal sts=0 sw=8 noexpandtab
 au Syntax vim setlocal commentstring=\"\ %s
augroup END

function! SetBeancountOptions()
  let @q = 'da"kopgcchxjA ""'
  inoremap <buffer> . .<C-\><C-O>:AlignCommodity<CR>
  nnoremap <buffer> <localleader>= :AlignCommodity<CR>
  vnoremap <buffer> <localleader>= :AlignCommodity<CR>
  nnoremap <buffer> <localleader># ?<C-r><C-a><CR>
  nnoremap <buffer> <localleader>* /<C-r><C-a><CR>
  nnoremap <buffer> <leader>R :%s/\<<C-r><C-a>\>/
endfunction

function! SetPythonOptions()
  setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  setlocal colorcolumn=80
  setlocal autoindent
endfunction

function! SetCOptions()
  setlocal softtabstop=8 shiftwidth=8 noexpandtab
  setlocal foldmethod=syntax
  normal zR
  setlocal colorcolumn=80
endfunction

""""""""""""""""""""
" Plugin_settings: "
""""""""""""""""""""

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
let g:NERDTreeChDirMode = 2

" Mucomplete:
" add neosnippets to mucomplete chain
" path = directories. Omni = omni-complete. nsnp = neosnippet
" keyn = local buffer. Dict = dictionary. Uspl = wrongly spelled
let g:mucomplete#chains = {
      \ 'vim'     : ['path', 'cmd', 'keyn'],
      \ 'default' : ['path', 'omni', 'nsnp', 'keyn',  'dict', 'uspl']
      \}
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0

" Neosnippet:
imap <C-u>     <Plug>(neosnippet_expand_or_jump)
smap <C-u>     <Plug>(neosnippet_expand_or_jump)
xmap <C-u>     <Plug>(neosnippet_expand_target)
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='$HOME/.vim/plugged/vim-snippets/snippets,$CLOUD_HOME/Syncs/Vim/snippets'

" ALE:
let g:ale_linters = {
      \   'python': ['flake8','pylint'],
      \}
let g:ale_fixers = {
      \   'python': ['yapf'],
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_linters_explicit = 1
nnoremap <F5> :ALEFix<CR>

" VimTex:
let g:tex_flavor = 'latex'
let g:tex_fast = "cmMprsSvV"
let g:vimtex_compiler_latexmk = {'build_dir' : 'latexbuild',}

" Beancount:
let g:beancount_separator_col = 61

" Python:
let g:python_pep8_indent_multiline_string = -2

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

" Appearance:
Plug 'itchyny/lightline.vim'                                              " Theme
Plug 'ayu-theme/ayu-vim'                                                  " Colorscheme

Plug 'christoomey/vim-tmux-navigator/'                                    " Allows pane change using TMUX
Plug 'junegunn/vim-easy-align'                                            " Improves = align using ga
Plug 'tpope/vim-commentary'                                               " Toggle comment using gc
Plug 'tpope/vim-surround'                                                 " Change/add surrounding ("[ etc
Plug 'scrooloose/nerdtree'                                                " Opens filetree using C-n in normal mode
Plug 'ludovicchabant/vim-gutentags'

" File Specifics:
Plug 'tpope/vim-apathy'                                                   " Set up $PATH correctly for C/C++/ObjectiveC/GO/JS/Lua/Python/Shell a.o.
Plug 'dense-analysis/ale'
Plug 'vhda/verilog_systemverilog.vim', { 'for': 'verilog_systemverilog' } " Extensions for coding in .sv
Plug 'lervag/vimtex', { 'for': 'tex' }                                    " Extensions for markup in .tex
Plug 'nathangrigg/vim-beancount', { 'for': 'beancount' }                  " Arranges completion for use with beancount accounting software
" Python:
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }                          " Fixes indentation in Python files
Plug 'davidhalter/jedi-vim', { 'for': 'python' }                          " LSP for Python files
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }                 " Correctly indents next line

call plug#end()

" Colorscheme:
set termguicolors
let ayucolor="dark"
colorscheme ayu
