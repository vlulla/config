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
" set colorcolumn=+1,+2,+3
set complete-=t     " no tag search
set completeopt=longest,menuone
set cpoptions+=W
set display=lastline,uhex
set esckeys
set expandtab
set fileformat=unix
set fillchars+=stl:-,stlnc:-,diff:-
set foldmethod=marker
set formatoptions=tcroqn1j
set history=10000
set hlsearch
" set ignorecase
set incsearch
set laststatus=2
set lazyredraw " Don't display macro steps
set listchars+=tab:>-,trail:.,precedes:<,extends:>
set matchtime=2
set modelines=5 " Mac's default vim sets it to 0??
set more
set nobackup
set nostartofline
set noswapfile
set nowritebackup
set path+=**
set ruler
set noscrollbind " Buffers scroll independently....need this!
set nrformats+=alpha " :help CTRL-A  OR :help nrformats
set nowrap
set scrolloff=2
set sessionoptions+=unix,slash
set shiftwidth=2
set showcmd
set showmatch
set showmode
" set sidescroll=5
" set sidescrolloff=3
set smartcase
" set smartindent
" set smarttab
set softtabstop=2
set splitright
set splitbelow
set textwidth=0
" set timeoutlen=1000 ttimeoutlen=10 " Comment these two lines to make leaders and mappings work!
set timeoutlen=150
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

set shortmess=a

" Doesn't work on my Mac OSX
" Use UTF-8
" set encoding=utf-8
" set termencoding=utf-8
" set fileencoding=utf-8

set statusline=%t-%m-%R-%Y-[ff:%{&fileformat}]-%=-[D:%3b,\ H:0x%02B]-[L:%3l/%3L(%3p%%),\ C:%2v]
highlight StatusLine cterm=bold
" highlight MatchParen cterm=bold ctermbg=none ctermfg=white
" highlight SpellBad term=reverse ctermfg=15 ctermbg=9 guifg=White guibg=Red
" highlight DiffText term=reverse ctermfg=15 ctermbg=9 guifg=White guibg=Red

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

" :help find-manpage
runtime! ftplugin/man.vim

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
autocmd BufRead,BufWinEnter,BufNewFile *.sed set filetype=sed
autocmd BufRead,BufWinEnter,BufNewFile *.awk set filetype=awk

autocmd BufRead,BufNewFile *.txt setlocal noet ts=4 sw=4 sts=4
autocmd BufRead,BufNewFile *.md,*.Rmd setlocal noet ts=4 sw=4 sts=4
autocmd BufRead,BufNewFile *.py setlocal ts=4 sw=4 sts=4

" https://unix.stackexchange.com/a/383044
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
autocmd FileChangedSHellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Cursorcolumn is helpful with yml files!
autocmd FileType yaml setlocal cursorcolumn cursorline noautoindent nocindent nosmartindent indentexpr=
autocmd BufWinEnter *.yml,*.yaml set indentexpr=

augroup Skeleton
    autocmd!
    " See :help template
    autocmd BufNewFile *.tex  0r ~/code/vim_templates/latextemplate.tex
    autocmd BufNewFile *.Rnw  0r ~/code/vim_templates/sweavetemplate.Rnw
    autocmd BufNewFile *.ly  0r ~/code/vim_templates/lilypondtemplate.ly
    autocmd BufNewFile Makefile  0r ~/code/vim_templates/Makefile
    autocmd BufNewFile *.R 0r ~/code/vim_templates/Rtemplate.R
    autocmd BufNewFile *.Rmd 0r ~/code/vim_templates/Rmdtemplate.Rmd
    autocmd BufNewFile *.sh 0r ~/code/vim_templates/shell-template.sh
    autocmd BufNewFile *.md 0r ~/code/vim_templates/mdtemplate.md
    autocmd BufNewFile *.py 0r ~/code/vim_templates/pythontemplate.py
    autocmd BufNewFile *.go 0r ~/code/vim_templates/gotemplate.go
    autocmd BufNewFile *.dot 0r ~/code/vim_templates/dottemplate.dot
    autocmd BufNewFile .gitignore 0r ~/code/vim_templates/gitignore
    autocmd BufNewFile .dockerignore 0r ~/code/vim_templates/dockerignore
    autocmd BufNewFile Dockerfile 0r ~/code/vim_templates/Dockerfile
    autocmd BufNewFile build.sbt 0r ~/code/vim_templates/build.sbt
    autocmd BufNewFile *.tex,*.Rnw,*.ly,Makefile,*.R,*.Rmd,*.md,*.sh,*.py,*.go,*.dot,.gitignore,.dockerignore,Dockerfile,build.sbt set modified
augroup END


autocmd FileType c,cs,cpp,java set cindent et fo=tcrq tw=78 ts=4 cinoptions=(0
autocmd FileType gitcommit setlocal spell tw=72
autocmd FileType j set tw=0
autocmd FileType java set makeprg=javac\ \"%\"
autocmd FileType lilypond nnoremap <leader>; :!open "%:p:r.pdf"<CR><CR>
autocmd FileType make set noet sw=8 ts=8 sts=8
autocmd FileType perl set smartindent
autocmd FileType python set makeprg=python\ \"%\"
autocmd FileType r set makeprg=R\ CMD\ BATCH\ -q\ --no-save\ --no-restore\ \"%\"
autocmd FileType scala set makeprg=scala\ \"%\"
autocmd FileType sql set syntax=OFF ignorecase

" Delete trailing whitespace for some of the programming file types...
autocmd FileType c,cs,cpp,java,python,r,scala,sql,make,sed,awk autocmd BufWritePre <buffer> %s@\s\+$@@e

let mapleader=","
" let mapleader="\<Space>"
" Saw the above on http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/

" Allow normal use of "," by pressing it twice  from https://github.com/begriffs/vimrc/blob/master/.vimrc
noremap ,, ,

map <silent> <leader><CR> :nohls<CR>

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
vmap <leader>s y:<C-U>%s@\<<C-R>"\>@@gc<Left><Left><Left>

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
nnoremap <expr> M ':%s@' . @/ . '@@gc<LEFT><LEFT><LEFT>'
nnoremap <silent> ;v :edit $MYVIMRC<CR>
nnoremap <Space> <C-F>
augroup VimReload
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" """ Need below to accomodate "hard line breaks" in markdown (pandoc)
autocmd BufWritePre * :%s@\s\{3,}$@@e

" map <CR> <ESC>:nohls<CR>

nnoremap <F2> :setlocal invcursorcolumn cursorcolumn?<CR>
imap <F2> <C-O><F2>
nnoremap <F3> :setlocal invcursorline cursorline?<CR>
imap <F3> <C-O><F3>
nnoremap <F4> :setlocal invwrap wrap?<CR>
imap <F4> <C-O><F4>
nnoremap <F5> :setlocal invhlsearch hlsearch?<CR>
imap <F5> <C-O><F5>
" Line numbers are useful for debugging.  Enable toggling line numbers.
nnoremap <F6> :setlocal invnumber number?<CR>
inoremap <F6> <C-O>:setlocal invnumber number?<CR>
" Neat idea from https://www.ukuug.org/events/linux2004/programme/paper-SMyers/Linux_2004_slides/vim_tips/
nnoremap <F7> :setlocal invpaste paste?<CR>
imap <F7> <C-O><F7>
set pastetoggle=<F7>
nnoremap <F8> :setlocal invspell spell?<CR>
imap <F8> <C-O><F8>
" AutoHotkey causes problem for normal mode mapping.  Check AHK to see if F9/F10/F11 is mapped there! 2017.09.21
nnoremap <F9> "=strftime("%Y.%m.%d")<CR>P
nnoremap <F10> "=strftime("%Y.%m.%dT%H:%M:%S%z")<CR>P
inoremap <F9> <C-R>=strftime("%Y.%m.%d")<CR>
inoremap <F10> <C-R>=strftime("%Y.%m.%dT%H:%M:%S%z")<CR>


"" https://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
" highlight OverLength term=standout cterm=bold ctermbg=red ctermfg=white gui=bold guibg=red guifg=white
highlight OverLength term=standout cterm=bold ctermbg=white ctermfg=black gui=bold guibg=red guifg=white
match OverLength /\%121v/

" Some abbreviations
iabbrev #d #define
iabbrev #i #include
iabbrev #f ## FIXME (vijay):
iabbrev #t ## TODO (vijay):
iabbrev THe The
iabbrev THat That
iabbrev THis This
iabbrev LV Vijay Lulla
iabbrev Afaict As far as I can tell
iabbrev afaict as far as I can tell
iabbrev Aiui As I understand it
iabbrev aiui as I understand it
iabbrev appl application
iabbrev appls applications
iabbrev attn attention
iabbrev btw by the way
iabbrev Btw By the way,
iabbrev BTW By the way,
" iabbrev ccopy Copyright 2022 Vijay Lulla, all rights reserved.
iabbrev didnt didn't
iabbrev dnt don't
iabbrev dont don't
iabbrev eg e.g.,
iabbrev exprot export
iabbrev fe for example
iabbrev fo of
iabbrev fucntion function
iabbrev htat that
iabbrev hte the
iabbrev ie i.e.,
iabbrev Iatm It appears to me
iabbrev Iirc If I remember correctly
iabbrev Iiuc If I understand correctly
iabbrev Istm It seems to me
iabbrev iatm it appears to me
iabbrev iirc if I remember correctly
iabbrev iiuc if I understand correctly
iabbrev imo in my opinion
iabbrev Imo In my opinion,
iabbrev IMO In my opinion,
iabbrev iotm it occurs to me
iabbrev Iotm It occurs to me
iabbrev istm it seems to me
iabbrev ive I've
iabbrev mins minutes
iabbrev nto not
iabbrev ofr for
iabbrev ot to
iabbrev pls please
iabbrev Pls Please
iabbrev si is
" iabbrev ssig --<CR>Vijay Lulla<CR>vijaylulla@gmail.com
iabbrev taht that
iabbrev teh the
iabbrev tfs thanks for sharing
iabbrev Tfs Thanks for sharing
iabbrev thx thanks
iabbrev Thx Thanks
iabbrev wnt won't
iabbrev wont won't
iabbrev yoru your


filetype off
" filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on

