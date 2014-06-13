" set verbose=9
set nocompatible

set autoindent
set nobackup
"set background=light

set backspace=eol,start,indent
"set cinoptions=(0,W4 " Python.vim has problem with this.
set cinoptions=(0 
set cmdheight=2
set cpoptions+=J

set cryptmethod=blowfish
set cursorline
" set display=uhex
set esckeys
set expandtab
set fillchars=stl:-,stlnc:-,vert:\|,fold:-,diff:-
set foldmethod=marker
set formatoptions=tcrqn
set history=1000
set hlsearch
set incsearch
set laststatus=2
set listchars=tab:>-,trail:.,eol:$
" set modelines=5
set more
" set number
set relativenumber
set ruler
set scrolloff=1
set shiftwidth=4
set showcmd
set showmatch
set showmode
set sidescrolloff=3
set smartindent
set smarttab
set softtabstop=4
set textwidth=72
" set nowrapscan
" set whichwrap=b,s,l,h
set viminfo='500,<100,s50,h,/50,:50
set wildmenu
set wildmode=list:longest,full

" Use UTF-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8

if exists("strftime")
  set statusline=%t%H-%m-%R-%y-%{strftime('[%Y/%m/%d-%H-%M]\ ')}-%=\|d:%03b\|h:0x%2B\|-[pos=%l,%v]\ [len=%L\ (%p%%)]
else
  set statusline=%t%H-%m-%R-%y-%=-\|d:%03b\|h:0x%2B\|-[pos=%l,%v]\ [len=%L\ (%p%%)]
endif

" set swapsync
set vb t_vb= " silence the bell
set nowrap

if has("syntax")
  " syntax on
  autocmd FileType diff syntax enable
endif

filetype on

let do_syntax_sel_menu=1
runtime! synmenu.vim

let loaded_matchparen=1 

au FileType c,cs,cpp,java set cindent fo=tcrq tw=78 tabstop=4
au FileType java set makeprg=java\ \"%\"
au FileType sql set syntax=OFF

au BufWinLeave *.c,*.cc,*.cpp,*.c++,*.cs,*.java mkview
au BufWinEnter *.c,*.cc,*.cpp,*.c++,*.cs,*.java silent loadview
au BufWinEnter,BufRead *.r,*.R,.Rprofile set cindent filetype=r

au FileType make set noexpandtab shiftwidth=8 tabwidth=8 softtabstop=8
au FileType xhtml,html set textwidth=0

autocmd BufNewFile *.py 0r $HOME/vim/skeleton.py


" nnoremap ; :
" nnoremap : ;

let mapleader="," 
"FIXME: mapping of ; & : impacts this mapping
" map <silent> <leader><CR> ;nohlsearch<CR>
map <silent> <leader><CR> :nohlsearch<CR>

nnoremap <leader>t yyPVr=jpVr=j
nnoremap <leader>1 yyPVr-jpVr-j
nnoremap <leader>2 yypVr=j
nnoremap <leader>3 yypVr-j
nnoremap <leader>4 yypVr`j
nnoremap <leader>5 yypVr'j
nnoremap <leader>6 yypVr.j
nnoremap <leader>7 yypVr~j
nnoremap <leader>8 yypVr*j


" Good idea from http://amix.dk/vim/vimrc.txt
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

nnoremap <F9> "=strftime("%Y-%m-%d")<CR>P
nnoremap <F10> "=strftime("%Y-%M-%dT%H:%M:%S")<CR>P
inoremap <F9> <C-R>=strftime("%Y-%m-%d")<CR>
inoremap <F10> <C-R>=strftime("%Y-%m-%dT%H:%M:%S")<CR>

" highlight search tmer
highlight Search gui=bold guifg=white guibg=blue

highlight LineNr guifg=white guibg=darkgray


" See http://amix.dk/vim/vimrc.txt
" Helper functions
function! Cmdline(str)
  exe "menu Foo.bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern=escape(@", '\\/.*$^~[]')
  let l:pattern=substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "<0d>"
  elseif a:direction == 'gv'
    call Cmdline("vimgrep " . '/' . l:pattern . '/' . ' **/*.')
  elseif a:direction == 'replace'
    call Cmdline("%s" . '/' . l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "<0d>"
  endif

  " Save previous registers
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Some abbreviations
iab THe The
iab THis This
iab teh the
iab appl applications
iab vj Vijay
iab VL Vijay Lulla
iab yoru your
iab #i #include
iab #d #define


if has("gui_running")
    if has("gui_win32")
        set guifont=Consolas:h9:cANSI
    endif
endif
