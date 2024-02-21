" Paths:
if has('win32')||has('win64')
  let $HOME="C:/Localdata/"
endif

if !exists('$CLOUD_HOME')
  let $CLOUD_HOME=$HOME
endif

" Plugins:
if has('nvim')
  call plug#begin(stdpath('data') . '/plugged')
    " Appearance:
    Plug 'Luxed/ayu-vim'
    Plug 'hoob3rt/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'

    " Lsp:
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Update parsers on update
    Plug 'ray-x/lsp_signature.nvim'
    " Completion:
    Plug 'hrsh7th/cmp-nvim-lsp'     " cmp source for lsps
    Plug 'hrsh7th/cmp-buffer'       " cmp source for buffers
    Plug 'hrsh7th/cmp-path'         " cmp source for filepaths
    Plug 'hrsh7th/cmp-cmdline'      " cmp source for cmdline
    Plug 'hrsh7th/cmp-omni'         " cmp source for omnipath
    Plug 'hrsh7th/cmp-vsnip'        " cmp source for vsnip
    Plug 'hrsh7th/nvim-cmp'         " cmp itself

    " Snippets:
    Plug 'hrsh7th/vim-vsnip'
    Plug 'rafamadriz/friendly-snippets'
    Plug 'honza/vim-snippets'

    " Navigation:
    Plug 'ludovicchabant/vim-gutentags'

    " Editing:
    Plug 'junegunn/vim-easy-align'                                            " Improves = align using ga
    Plug 'tpope/vim-commentary'                                               " Toggle comment using gc
    Plug 'tpope/vim-surround'                                                 " Change/add surrounding ("[ etc
    Plug 'tpope/vim-fugitive'                                                 " Edit git from vim

    " File_specific:
    Plug 'lervag/vimtex', { 'for': 'tex' }                                    " Extensions for markup in .tex
    Plug 'nathangrigg/vim-beancount', { 'for': 'beancount' }                  " Arranges completion for use with beancount accounting software

  call plug#end()
endif

" Colorscheme:
set termguicolors
let ayucolor="dark"
colorscheme ayu
set list

exec 'luafile '.stdpath('config').'/lua/nvim-cmp.lua'
exec 'luafile '.stdpath('config').'/lua/lsp.lua'
exec 'luafile '.stdpath('config').'/lua/misc.lua'

""""""""""""
" Options: "
""""""""""""

set modeline

" Visual:
set number relativenumber
augroup numbertoggle
  au!
  au BufEnter,FocusGained,InsertLeave * set relativenumber
  au BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set title
set noshowmode
set noshowcmd
set visualbell

" Completion:
set wildmode=longest:full,full
set wildmenu
set completeopt=menu,menuone,noselect,preview
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

" Format: Soft wrapping, proper backspace behavior
set linebreak
set nojoinspaces

" Tabs:
set tabstop=8 softtabstop=2 shiftwidth=2 expandtab
set shiftround

" Search:
set ignorecase smartcase
for s:c in ['a', 'A', '<Insert>', 'i', 'I', 'gI', 'gi', 'o', 'O']
    exe 'nnoremap ' . s:c . ' :nohlsearch<CR>' . s:c
endfor " clear highlight when inserting

" Splits:
set splitbelow
set splitright

set clipboard=unnamed
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
set writebackup
set fileformat=unix


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
" A rename function
nnoremap <leader>r :%s/\<<C-r><C-w>\>/<C-r><C-w>
" move lines
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
" Access tags from non-regular keyboards
nnoremap <leader>t g<C-]>
" Make keybinds behave like most other vim keybinds
nnoremap Y y$
" Keeping the cursor centered when jumping around
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
" Save large jumps to jumplist
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

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
 au Syntax beancount call SetBeancountOptions()
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
  inoremap <buffer> ,, =>
  inoremap <buffer> ;; ->
endfunction

function! SetBeancountOptions()
  let @q = 'da"kopgcchxjA ""'
  inoremap <buffer> . .<C-\><C-O>:AlignCommodity<CR>
  nnoremap <buffer> <localleader>= :AlignCommodity<CR>
  nnoremap <buffer> <localleader># ?<C-r><C-a><CR>
  nnoremap <buffer> <localleader>* /<C-r><C-a><CR>
  nnoremap <buffer> <leader>R :%s/\<<C-r><C-a>\>/
endfunction

""""""""""""""""""""
" Plugin_settings: "
""""""""""""""""""""

" Vim_easy_align:
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" VimTex:
let g:tex_flavor = 'latex'
let g:tex_fast = "cmMprsSvV"
let g:vimtex_compiler_latexmk = {'build_dir' : 'latexbuild',}

" Beancount:
let g:beancount_separator_col = 61

" vnsip:
" Expand or jump
imap <expr> <C-u>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-u>'
smap <expr> <C-u>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-u>'
exec 'let g:vsnip_snippet_dir='''.stdpath('data').'/plugged/vim-snippets/snippets'''
