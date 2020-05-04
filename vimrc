" set verbose=9  " uncomment this to see all the stuff that vim is doing

set nocompatible
syntax off

set autoindent
set autoread
set autowrite
" set background=light

set backspace=eol,start,indent
set cinoptions=(0
set cmdheight=2
" set colorcolumn=80
set complete-=t     " no tag search
set completeopt=longest,menuone
set cpoptions+=JW
" set cursorcolumn
" set cursorline
" set display=lastline,uhex
set display=lastline
set esckeys
set expandtab
set fillchars=stl:-,stlnc:-,vert:\|,fold:-,diff:-
set foldmethod=marker
set formatoptions=tcroqn1j
set history=10000
set hlsearch
" set ignorecase
set incsearch
set laststatus=2
set lazyredraw " Don't display macro steps
set listchars=tab:>-,trail:.,eol:$,precedes:<,extends:>
set matchtime=2
set modelines=5 " Mac's default vim sets it to 0??
set more
set nobackup
set nostartofline
set noswapfile
set nowritebackup
" set number
set path+=**
" set relativenumber
set ruler
set noscrollbind " Buffers scroll independently....need this!
set nrformats+=alpha " :help CTRL-A  OR :help nrformats
set nowrap
set scrolloff=2
set sidescrolloff=3
set shiftwidth=2
set showcmd
set showmatch
set showmode
set sidescrolloff=3
set smartcase
" set smartindent
set smarttab
set softtabstop=4
set splitright
set splitbelow
set textwidth=0
" set timeoutlen=1000 ttimeoutlen=10 " Comment these two lines to make leaders and mappings work!
" set nowrapscan
" set whichwrap=b,s,l,h
set whichwrap=b,s,l,h,<,>,[,]
set viminfo='200,f1,<100,h,/50,:50

set wildmenu
set wildmode=list:longest,full
set wildignore+=.git,.svn,.hg
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.jpg,*.bmp,*.png,*.tif,*.jpeg
set wildignore+=*.o,*.obj,*.a,*.exe,*.dll,*.manifest
set wildignore+=*.spl
set wildignore+=*.sw?
set wildignore+=*.DS_Store
set wildignore+=*.luac
set wildignore+=*.pyc
set wildignore+=*.orig


" Doesn't work on my Mac OSX
" Use UTF-8
" set encoding=utf-8
" set termencoding=utf-8
" set fileencoding=utf-8

"" if exists("*strftime")
""   set statusline=%t-%m-%R-%y-%{strftime('%Y.%m.%d-%H:%M')\ }-%=\|d:%03b\|h:0x%02B\|-[pos=%l,%v]\ [len=%L\ (%p%%)]
"" else
""   set statusline=%t-%m-%R-%Y-%=-\|d:%03b\|h:0x%02B\|-[pos=%l,%v]\ [len=%L\ (%p%%)]
"" endif
set statusline=%t-%m-%R-%Y-%=[%{&fileformat}]-[d:%03b\ h:0x%02B]-[L:%3l,C:%3v]-[%3p%%]
highlight StatusLine cterm=bold

set swapsync=sync
autocmd GUIEnter * set vb t_vb= " silence the bell
autocmd VimEnter * set vb t_vb= " silence the bell

if has("syntax")
  " syntax on
  autocmd FileType diff syntax enable
endif

" filetype on

let do_syntax_sel_menu=1
runtime! synmenu.vim

" let loaded_matchparen=1

" Change diretories automatically " From Markus Motl's vimrc
" autocmd BufEnter * lcd %:p:h
" Above interferes with :find and path variable.  Just stay in top directory
" and use :find to look for files.

" autocmd BufWritePost * mkview
" autocmd BufRead * silent loadview

autocmd BufWinLeave *.c,*.cc,*.cpp,*.c++,*.java,*.R,*.r,*.Rmd,*.py,*.ijs mkview
autocmd BufWinEnter *.c,*.cc,*.cpp,*.c++,*.java,*.R,*.r,*.Rmd,*.py,*.ijs silent loadview
" autocmd BufWinEnter,BufRead *.r,*.R,.Rprofile set filetype=r sw=2 cindent
autocmd BufRead,BufNewFile *.ijs,*.ijt,*.ijp,*.ijx setfiletype j
autocmd BufRead,BufWinEnter,BufNewFile *.ly set filetype=lilypond
autocmd BufRead,BufWinEnter,BufNewFile *.r,*.R set filetype=r
" autocmd BufWinEnter * call ClearSyntax()

autocmd BufRead,BufNewFile *.txt setlocal noet ts=4 sw=4 sts=4
autocmd BufRead,BufNewFile *.md setlocal noet ts=4 sw=4 sts=4
autocmd BufRead,BufNewFile *.Rmd setlocal noet ts=4 sw=4 sts=4

" Cursorcolumn is helpful with yml files!
autocmd FileType yaml set cursorcolumn
autocmd BufWinLeave,BufLeave *.yml,*.yaml set nocursorcolumn

augroup Skeleton
    autocmd!
    " See :help template
    autocmd BufNewFile *.tex  0r ~/code/vim_emacs/vim_templates/latextemplate.tex
    autocmd BufNewFile *.Rnw  0r ~/code/vim_emacs/vim_templates/sweavetemplate.Rnw
    autocmd BufNewFile *.ly  0r ~/code/vim_emacs/vim_templates/lilypondtemplate.ly
    autocmd BufNewFile Makefile  0r ~/code/vim_emacs/vim_templates/Makefile
    autocmd BufNewFile *.R 0r ~/code/vim_emacs/vim_templates/Rtemplate.R
    autocmd BufNewFile *.Rmd 0r ~/code/vim_emacs/vim_templates/Rmdtemplate.Rmd
    autocmd BufNewFile *.py 0r ~/code/vim_emacs/vim_templates/pythontemplate.py
    autocmd BufNewFile *.go 0r ~/code/vim_emacs/vim_templates/gotemplate.go
    autocmd BufNewFile .gitignore 0r ~/code/vim_emacs/vim_templates/gitignore
    autocmd BufNewFile .dockerignore 0r ~/code/vim_emacs/vim_templates/dockerignore
    autocmd BufNewFile *.tex,*.Rnw,*.ly,Makefile,*.R,*.Rmd,*.py,*.go,.gitignore,.dockerignore set modified
augroup END

""" autocmd WinLeave * set nocursorline nocursorcolumn
""" autocmd WinEnter * set cursorline cursorcolumn

autocmd FileType c,cs,cpp,java set cindent et fo=tcrq tw=78 ts=4 cinoptions=(0
autocmd FileType gitcommit setlocal spell tw=72
autocmd FileType j set tw=0
autocmd FileType java set makeprg=javac\ \"%\"
autocmd FileType lilypond set makeprg=~/Applications/Lilypond.app/Contents/Resources/bin/lilypond\ \"%\"
autocmd FileType lilypond nnoremap <leader>; :!open "%:p:r.pdf"<CR><CR>
autocmd FileType make set noet sw=8 ts=8 sts=8
autocmd FileType perl set smartindent
autocmd FileType python set makeprg=python\ \"%\"
autocmd FileType r set makeprg=R\ CMD\ BATCH\ -q\ --no-save\ --no-restore\ \"%\"
autocmd FileType scala set makeprg=scala\ \"%\"
" autocmd FileType sql set syntax=OFF

let mapleader=","
" let mapleader="\<Space>"
" Saw the above on http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/

" Allow normal use of "," by pressing it twice  from https://github.com/begriffs/vimrc/blob/master/.vimrc
noremap ,, ,

map <silent> <leader><CR> :nohls<CR>
" Don't use it as much as I thought I would! 2019.01.13
" nnoremap <leader>t yyPVr=jpVr=j
" inoremap <leader>t <Esc>kyyPVr=jpVr=o
" <leader>N where N is the heading level
" Below are for setting section decorators for reStructuredText
" nnoremap <leader>1 yypVr=j
" nnoremap <leader>2 yypVr-j
" nnoremap <leader>3 yypVr`j
" nnoremap <leader>4 yypVr'j
" nnoremap <leader>5 yypVr.j
" nnoremap <leader>6 yypVr~j
" nnoremap <leader>7 yypVr*j
" Only used below if you're doing markdown!  Everywhere else it is annoying!
" inoremap <leader>1 <Esc>kyypVr=j
" inoremap <leader>2 <Esc>yypVr-j
" inoremap <leader>3 <Esc>yypVr`j
" inoremap <leader>4 <Esc>yypVr'j
" inoremap <leader>5 <Esc>yypVr.j
" inoremap <leader>6 <Esc>yypVr~j
" inoremap <leader>7 <Esc>yypVr*j

" From http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
inoremap jk <esc>

nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>

" map <leader>so :so %<CR>
" imap <leader>so <Esc>,so i

nnoremap <leader>z ^i/* A */
" imap <leader>z <Esc>,z i
nnoremap <leader>// ^i//
" imap <leader>// <Esc>,// <Esc>

" Some more useful ideas from Markus Motl's vimrc
nnoremap <leader>M :make<CR>
nnoremap <leader>m :make<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>st :st<CR>
" nnoremap <leader>p :exec '!python' shellescape(@%,1)<cr>


" From http://rayninfo.co.uk/vimtips.html
vnoremap < <gv
vnoremap > >gv
vmap // y/<C-R>"<CR>
vmap <leader>s y:<C-U>%s@\<<C-R>"\>@

"" nnoremap <C-J> <C-W><C-J>
"" nnoremap <C-K> <C-W><C-K>
"" nnoremap <C-L> <C-W><C-L>
"" nnoremap <C-H> <C-W><C-H>
map <C-n> :cnext<CR>
map <C-p> :cprev<CR>
imap <C-a> <C-o>^
imap <C-e> <C-o>$

" Excellent ew/es/ev/et mappings from http://vimcasts.org/episodes/the-edit-command/
cnoremap %% <C-R>=fnameescape(expand('%:p:h')).'/'<cr>
map <leader>ew :edit %%
map <leader>es :split %%
map <leader>ev :vsplit %%
map <leader>et :tabedit %%

" Great idea from http://howivim.com/2016/damian-conway/
nmap <expr> M ':%s@' . @/ . '@@gc<LEFT><LEFT><LEFT>'
nmap <silent> ;v :next $MYVIMRC<CR>
augroup VimReload
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

""" Don't need these since I delete trailing whitespaces before writing!
""" " highlight trailing white space!
""" highlight TrailingWhiteSpace ctermbg=Grey guibg=LightRed
""" match TrailingWhiteSpace /\s\+$/
" Delete trailing white space before writing
autocmd BufWritePre * :%s@\s\+$@@e

" map <CR> <ESC>:nohls<CR>

" Good idea from http://amix.dk/vim/vimrc.txt
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Line numbers are useful for debugging.  Enable toggling line numbers.
nnoremap <F6> :set invnumber number?<CR>
inoremap <F6> <C-O>:set invnumber number?<CR>
nnoremap <F2> :set invcursorcolumn cursorcolumn?<CR>
inoremap <F2> <C-O><F2>
nnoremap <F3> :set invwrap wrap?<CR>
" inoremap <F3> <C-O>:set invwrap wrap?<CR>
imap <F3> <C-O><F3>
nnoremap <F5> :set invhls hls?<CR>
imap <F5> <C-O><F5>
nnoremap <F4> :set invspell spell?<CR>
imap <F4> <C-O><F4>

" From :help pastetoggle
" nnoremap <F7> :set paste<CR>
" nnoremap <F8> :set nopaste<CR>
" inoremap <F7> <C-O>:set paste<CR>
" inoremap <F8> <nop>
" set pastetoggle=<F8>
" set pastetoggle=<F2> " From Markus Motl's vimrc file!

" Neat idea from https://www.ukuug.org/events/linux2004/programme/paper-SMyers/Linux_2004_slides/vim_tips/
nnoremap <F7> :set invpaste paste?<CR>
imap <F7> <C-O><F7>
set pastetoggle=<F7>

" AutoHotkey causes problem for normal mode mapping.  Check AHK to see if F9/F10/F11 is mapped there! 2017.09.21
nnoremap <F9> "=strftime("%Y.%m.%d")<CR>P
nnoremap <F10> "=strftime("%Y.%m.%dT%H:%M:%S%z")<CR>P
inoremap <F9> <C-R>=strftime("%Y.%m.%d")<CR>
inoremap <F10> <C-R>=strftime("%Y.%m.%dT%H:%M:%S%z")<CR>

" hi Search term=bold ctermfg=white ctermbg=red
" hi Visual term=reverse cterm=reverse
" hi StatusLine term=bold cterm=bold gui=bold
" hi LineNr ctermfg=lightgray cterm=reverse
" hi CursorLine term=reverse ctermbg=15 ctermfg=0 cterm=NONE
" hi CursorColumn term=reverse ctermbg=15 ctermfg=0 cterm=NONE
" hi MatchParen ctermbg=none cterm=reverse

"" https://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
" hi OverLength ctermbg=red ctermfg=white
" match OverLength /\%81v.\+/

" See http://amix.dk/vim/vimrc.txt
" Helper functions
function! Cmdline(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . ""
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/' . l:pattern . '/' . ' **/*.')
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/' . l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . ""
  endif

  " Save previous registers
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Idea from https://vi.stackexchange.com/a/10456
function! ClearSyntax()
  syntax on
  let syn = split(execute('syntax list'), "\n")[1:]
  call filter(syn, {k,v -> match(v, '^\v') > -1})
  call map(syn, {k,v -> split(v)[0]})
  for i in syn
    if match(i, '\c\mcomment') == -1
      try
        exe 'syntax clear ' i
      catch /E28/
      endtry
    endif
  endfor
endfunction


" Some abbreviations
iab #d #define
iab #i #include
iab THe The
iab THis This
iab VL Vijay Lulla
iab appl applications
iab fo of
iab htat that
iab hte the
iab nto not
iab ofr for
iab ot to
iab si is
iab taht that
iab teh the
iab yoru your


filetype off
" filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on

