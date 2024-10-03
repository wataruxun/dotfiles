" plugin
set helplang=ja
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode=1
let g:airline_powerline_fonts=1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab
let g:airline#extensions#tabline#buffer_idx_format = {
	\ '0': '0 ',
	\ '1': '1 ',
	\ '2': '2 ',
	\ '3': '3 ',
	\ '4': '4 ',
	\ '5': '5 ',
	\ '6': '6 ',
	\ '7': '7 ',
	\ '8': '8 ',
	\ '9': '9 '
	\}
let g:airline_theme='powerlineish'
let g:table_mode_corner = '|'
let NERDTreeShowHidden = 1
nmap <C-b> :NERDTreeToggle<CR>

" --- plugin management ---
" dein.vim settings {{{
" install dir {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" begin settings {{{
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " .toml file
  let s:rc_dir = expand('~/.vim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'

  " read toml and cache
  call dein#load_toml(s:toml, {'lazy': 0})

  " end settings
  call dein#end()
  call dein#save_state()
endif
" }}}

" plugin installation check {{{
if dein#check_install()
  call dein#install()
endif
" }}}

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}
" --- plugin management ---

" display
set number
set ambiwidth=double

" cursor
set cursorline
set cursorcolumn
set showmatch


" search
set hlsearch
set incsearch
set ignorecase
set smartcase

" undo hilight
if has('persistent_undo')
    let undo_path=expand('~/.vim/undo')
    exe 'set undodir=' ..undo_path
    set undofile
endif

" indent
set smartindent
set autoindent
filetype plugin indent on

" clipboard
set clipboard+=unnamed

" syntax
syntax enable

" status line
set laststatus=2
set wildmenu
set ruler
set showcmd

" mouse
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" ---custom kaymap---
" open .vimrc
nnoremap <C-s> :new ~/.vimrc<CR>
" esc esc: delete highlight
nnoremap <Esc><Esc> :nohlsearch<CR>
" ---custom kaymap---
